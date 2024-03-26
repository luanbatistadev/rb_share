import 'package:flutter/material.dart';
import 'package:rb_share/gen/strings.g.dart';
import 'package:rb_share/model/persistence/favorite_device.dart';
import 'package:rb_share/provider/favorites_provider.dart';
import 'package:rb_share/provider/network/targeted_discovery_provider.dart';
import 'package:rb_share/provider/settings_provider.dart';
import 'package:rb_share/theme.dart';
import 'package:rb_share/widget/dialogs/favorite_edit_dialog.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:routerino/routerino.dart';

/// A dialog showing a list of favorites
class FavoritesDialog extends StatefulWidget {
  const FavoritesDialog({super.key});

  @override
  State<FavoritesDialog> createState() => _FavoritesDialogState();
}

class _FavoritesDialogState extends State<FavoritesDialog> with Refena {
  bool _fetching = false;
  bool _failed = false;

  /// Checks if the device is reachable and pops the dialog with the result if it is.
  Future<void> _checkConnectionToDevice(FavoriteDevice favorite) async {
    setState(() {
      _fetching = true;
    });

    final https = ref.read(settingsProvider).https;

    final result = await ref
        .read(targetedDiscoveryProvider)
        .discover(ip: favorite.ip, port: favorite.port, https: https);
    if (result == null) {
      setState(() {
        _fetching = false;
        _failed = true;
      });
      return;
    }

    if (!mounted) {
      return;
    }

    context.pop(result);
  }

  Future<void> _showDeviceDialog([FavoriteDevice? favorite]) async {
    await showDialog(context: context, builder: (_) => FavoriteEditDialog(favorite: favorite));
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);

    return AlertDialog(
      title: Text(t.dialogs.favoriteDialog.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (favorites.isEmpty)
            Text(
              t.dialogs.favoriteDialog.noFavorites,
              style: const TextStyle(color: Colors.grey),
            ),
          for (final favorite in favorites)
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onSurface,),
                    onPressed:
                        _fetching ? null : () async => await _checkConnectionToDevice(favorite),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${favorite.alias}\n(${favorite.ip})'),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onSurface,),
                  onPressed: _fetching ? null : () async => await _showDeviceDialog(favorite),
                  child: const Icon(Icons.edit),
                ),
              ],
            ),
          if (_failed)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(t.general.error,
                  style: TextStyle(color: Theme.of(context).colorScheme.warning),),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(t.general.cancel),
        ),
        FilledButton(
          onPressed: _showDeviceDialog,
          child: Text(t.dialogs.favoriteDialog.addFavorite),
        ),
      ],
    );
  }
}

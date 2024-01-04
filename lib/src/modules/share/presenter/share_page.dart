import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rb_share/src/core/di/di.dart';
import 'package:rb_share/src/core/entities/connection_status.dart';
import 'package:rb_share/src/core/provider/connection_provider.dart';
import 'package:rb_share/src/core/provider/file_provider.dart';
import 'package:rb_share/src/core/repository/file_repository.dart';
import 'package:rb_share/src/core/utils/constants.dart';
import 'package:rb_share/src/core/utils/extension.dart';
import 'package:rb_share/src/core/utils/styles.dart';
import 'package:rb_share/src/core/utils/utility_functions.dart';
import 'package:rb_share/src/core/widgets/list_file/list_shared_files_widget.dart';
import 'package:rb_share/src/modules/share/presenter/navigation_widget.dart';
import 'package:rb_share/src/modules/share/submodules/scan_qr_code/presenter/widget/connect_widget.dart';

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final fileRepository = getIt.get<FileRepository>();
  _disconnect() {
    context.read<ConnectionProvider>().disconnect();
    context.read<FileProvider>().clearAllFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionProvider>(builder: (BuildContext ct, value, Widget? child) {
      final connectionStatus = value.connectionStatus;
      final connectedIPAddress = value.connectedIPAddress;
      final isConnected = connectionStatus == ConnectionStatus.connected;
      return Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                isConnected
                    ? const Icon(Icons.circle, size: 12.0, color: Colors.green)
                    : const Icon(Icons.circle, size: 12.0, color: Colors.grey),
                const SizedBox(width: 6.0),
                Text(
                  connectedIPAddress,
                  style: CommonTextStyle.textStyleNormal.copyWith(color: textIconButtonColor),
                ),
              ],
            ),
            isConnected
                ? IconButton(
                    onPressed: () {
                      _disconnect();
                    },
                    icon: const Icon(Icons.link_off),
                  )
                : IconButton(
                    onPressed: () => _onClickManualButton(),
                    icon: const Icon(Icons.link),
                  ),
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NavigationWidgets(connectionStatus: connectionStatus),
              const Expanded(child: ListSharedFiles()),
              Container(
                margin: const EdgeInsets.only(bottom: 12.0, left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !UtilityFunctions.isMobile
                        ? Row(
                            children: [
                              FloatingActionButton.extended(
                                heroTag: const Text("Scan"),
                                onPressed: () => _onClickScanButton(),
                                label: Text(
                                  'Scan to connect',
                                  style: CommonTextStyle.textStyleNormal.copyWith(
                                    color: textIconButtonColor,
                                    fontSize: 14.0,
                                  ),
                                ),
                                icon: const Icon(Icons.qr_code_scanner, color: textIconButtonColor),
                              ),
                              const SizedBox(width: 16.0),
                            ],
                          )
                        : const SizedBox.shrink(),
                    Flexible(
                      child: FloatingActionButton.extended(
                        heroTag: const Text("Manual"),
                        onPressed: () => _onClickManualButton(),
                        label: Text(
                          'Manual connect',
                          style: CommonTextStyle.textStyleNormal.copyWith(
                            color: textIconButtonColor,
                            fontSize: 14.0,
                          ),
                        ),
                        icon: const Icon(Icons.account_tree, color: textIconButtonColor),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  _onClickScanButton() async {
    final isPermissionGranted = await UtilityFunctions.checkCameraPermission(
      onPermanentlyDenied: () => context.showOpenSettingsDialog(),
    );
    if (isPermissionGranted) {
      if (mounted) {
        final result = await context.pushNamed<bool>(mScanningPath);
        if (result == true) {
          _syncFiles();
        }
      }
    } else {
      if (mounted) {
        context.showSnackbar('Need Camera permission to continue');
      }
    }
  }

  _syncFiles() async {
    final files = (await fileRepository.getSharedFilesWithState()).getOrElse(() => {});
    if (mounted) {
      context.read<FileProvider>().addAllSharedFiles(sharedFiles: files);
    }
  }

  _onClickManualButton() {
    // if(UtilityFunctions.isDesktop) {
    //   showDialog(
    //     context: context,
    //     builder: (bsContext) {
    //       return Dialog(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(16.0),
    //         ),
    //         child: ConstrainedBox(
    //           constraints: BoxConstraints(
    //             maxWidth: MediaQuery.of(context).size.width / 2,
    //             maxHeight: MediaQuery.of(context).size.height / 2,
    //           ),
    //           child: ConnectWidget(onConnected: () async {
    //             Navigator.pop(context);
    //             _syncFiles();
    //           }),
    //         ),
    //       );
    //     },
    //   );
    // } else {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (bsContext) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ConnectWidget(onConnected: () async {
            Navigator.pop(context);
            _syncFiles();
          }),
        );
      },
    );
    // }
  }
}

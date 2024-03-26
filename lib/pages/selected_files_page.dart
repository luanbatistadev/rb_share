import 'dart:convert';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:rb_share/gen/strings.g.dart';
import 'package:rb_share/provider/selection/selected_sending_files_provider.dart';
import 'package:rb_share/util/file_size_helper.dart';
import 'package:rb_share/util/native/open_file.dart';
import 'package:rb_share/util/ui/nav_bar_padding.dart';
import 'package:rb_share/widget/dialogs/message_input_dialog.dart';
import 'package:rb_share/widget/file_thumbnail.dart';
import 'package:rb_share/widget/responsive_list_view.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:routerino/routerino.dart';

class SelectedFilesPage extends StatelessWidget {
  const SelectedFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = context.ref;
    final selectedFiles = ref.watch(selectedSendingFilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.sendTab.selection.title),
      ),
      body: ResponsiveListView.single(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        tabletPadding: const EdgeInsets.symmetric(horizontal: 15),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(height: 15),
            ),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.sendTab.selection.files(files: selectedFiles.length)),
                        Text(t.sendTab.selection.size(
                            size: selectedFiles
                                .fold(0, (prev, curr) => prev + curr.size)
                                .asReadableFileSize,),),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      ref.redux(selectedSendingFilesProvider).dispatch(ClearSelectionAction());
                      context.popUntilRoot();
                    },
                    child: Text(t.selectedFilesPage.deleteAll),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: selectedFiles.length,
                (context, index) {
                  final file = selectedFiles[index];

                  final String? message;
                  if (file.fileType == FileType.text && file.bytes != null) {
                    message = utf8.decode(file.bytes!);
                  } else {
                    message = null;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: file.path != null
                          ? () async => openFile(context, file.fileType, file.path!)
                          : null,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              SmartFileThumbnail.fromCrossFile(file),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message != null
                                          ? '"${message.replaceAll('\n', ' ')}"'
                                          : file.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                    ),
                                    Text(file.size.asReadableFileSize,
                                        style: Theme.of(context).textTheme.bodySmall,),
                                  ],
                                ),
                              ),
                              if (file.fileType == FileType.text && file.bytes != null)
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  onPressed: () async {
                                    final result = await showDialog<String>(
                                        context: context,
                                        builder: (_) => MessageInputDialog(initialText: message),);
                                    if (result != null) {
                                      ref.redux(selectedSendingFilesProvider).dispatch(
                                          UpdateMessageAction(message: result, index: index),);
                                    }
                                  },
                                  child: const Icon(Icons.edit),
                                ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                                ),
                                onPressed: () {
                                  final currCount = ref.read(selectedSendingFilesProvider).length;
                                  ref
                                      .redux(selectedSendingFilesProvider)
                                      .dispatch(RemoveSelectedFileAction(index));
                                  if (currCount == 1) {
                                    context.popUntilRoot();
                                  }
                                },
                                child: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 15 + getNavBarPadding(context)),
            ),
          ],
        ),
      ),
    );
  }
}

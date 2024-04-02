import 'package:flutter/material.dart';
import 'package:rb_share/gen/strings.g.dart';
import 'package:rb_share/pages/selected_files_page.dart';
import 'package:rb_share/pages/tabs/send_tab_vm.dart';
import 'package:rb_share/util/file_size_helper.dart';
import 'package:rb_share/util/native/file_picker.dart';
import 'package:rb_share/widget/big_button.dart';
import 'package:rb_share/widget/dialogs/add_file_dialog.dart';
import 'package:rb_share/widget/file_thumbnail.dart';
import 'package:rb_share/widget/responsive_list_view.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:routerino/routerino.dart';

const _horizontalPadding = 15.0;
final _options = FilePickerOption.getOptionsForPlatform();

class ChooseFiles extends StatefulWidget {
  final VoidCallback callback;

  const ChooseFiles({super.key, required this.callback});

  @override
  State<ChooseFiles> createState() => _ChooseFilesState();
}

class _ChooseFilesState extends State<ChooseFiles> {
  @override
  Widget build(BuildContext context) {
    final badgeColor = Theme.of(context).colorScheme.secondaryContainer;

    return ViewModelBuilder(
      provider: sendTabVmProvider,
      init: (context, ref) {
        // ignore: discarded_futures
        ref.dispatchAsync(SendTabInitAction(context));
      },
      builder: (context, vm) {
        final ref = context.ref;
        return Scaffold(
          floatingActionButton: vm.selectedFiles.isEmpty
              ? null
              : FloatingActionButton(
                  onPressed: widget.callback,
                  backgroundColor: badgeColor,
                  child: const Icon(Icons.arrow_forward_rounded),
                ),
          body: Center(
            child: ResponsiveListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 20),
                if (vm.selectedFiles.isEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
                    child: Text(
                      t.sendTab.selection.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        ..._options.map((option) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            child: BigButton(
                              icon: option.icon,
                              label: option.label,
                              filled: false,
                              onTap: () async => ref.dispatchAsync(
                                PickFileAction(
                                  option: option,
                                  context: context,
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ] else ...[
                  Card(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                      left: _horizontalPadding,
                      right: _horizontalPadding,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.sendTab.selection.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 5),
                          Text(t.sendTab.selection.files(files: vm.selectedFiles.length)),
                          Text(
                            t.sendTab.selection.size(
                              size: vm.selectedFiles
                                  .fold(0, (prev, curr) => prev + curr.size)
                                  .asReadableFileSize,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: defaultThumbnailSize,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: vm.selectedFiles.length,
                              itemBuilder: (context, index) {
                                final file = vm.selectedFiles[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SmartFileThumbnail.fromCrossFile(file),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                                ),
                                onPressed: () async {
                                  await context.push(() => const SelectedFilesPage());
                                },
                                child: Text(t.general.edit),
                              ),
                              const SizedBox(width: 15),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                ),
                                onPressed: () async {
                                  if (_options.length == 1) {
                                    // open directly
                                    await ref.dispatchAsync(
                                      PickFileAction(
                                        option: _options.first,
                                        context: context,
                                      ),
                                    );
                                    return;
                                  }
                                  await AddFileDialog.open(
                                    context: context,
                                    options: _options,
                                  );
                                },
                                icon: const Icon(Icons.add),
                                label: Text(t.general.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

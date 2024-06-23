// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/extensions/flutter_extensions.dart';
import 'package:edocs_mobile/core/global/constants.dart';
import 'package:edocs_mobile/features/document_upload/view/document_upload_preparation_page.dart';
import 'package:edocs_mobile/features/saved_view_details/view/saved_view_non_Expandsion_preview.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/helpers/message_helpers.dart';
import 'package:edocs_mobile/routing/routes/folder_route.dart';
import 'package:edocs_mobile/routing/routes/labels_route.dart';
import 'package:edocs_mobile/routing/routes/scanner_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderTree extends StatefulWidget {
  const FolderTree({
    Key? key,
    this.expandChildrenOnReady = false,
    required this.tree,
    this.node,
  }) : super(key: key);

  final bool expandChildrenOnReady;
  final TreeNode<dynamic> tree;
  final TreeNode? node;

  @override
  State<FolderTree> createState() => _FolderTreeState();
}

class _FolderTreeState extends State<FolderTree> {
  TreeViewController? _controller;
  final Map<String, bool> isLoading = {};

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverTreeView.simple(
        tree: widget.tree,
        showRootNode: true,
        expansionIndicatorBuilder: (context, node) =>
            ChevronIndicator.rightDown(
          alignment: Alignment.centerRight,
          tree: node,
          padding: const EdgeInsets.all(16),
        ),
        indentation: const Indentation(style: IndentStyle.squareJoint),
        onTreeReady: (controller) {
          _controller = controller;
          if (widget.expandChildrenOnReady) {
            controller.expandAllChildren(widget.tree);
          }
        },
        focusToNewNode: true,
        onItemTap: (value) {},
        builder: (context, node) {
          return node.level == 0
              ? GestureDetector(
                  onLongPressStart: (details) {
                    _showPopupMenu(context, details.globalPosition, node.data,
                        false, node.key, node);
                  },
                  child: Card(
                    child: ListTile(
                      title: widget.node != null
                          ? Text(widget.node!.data!.getValue('name') ?? '')
                          : Text(S.of(context)!.personalMaterial),
                      subtitle: widget.node != null
                          ? const Text('Thư mục và Tài liệu')
                          : Text(S.of(context)!.allFileAndFolder),
                    ),
                  ),
                )
              : GestureDetector(
                  onLongPressStart: (details) {
                    if (node.data is Folder) {
                      _showPopupMenu(context, details.globalPosition, node.data,
                          true, node.key, node);
                    }
                  },
                  child: node.data.hasField(node.data.toJson(), 'mime_type')
                      ? const ListTile(
                          title: Text('aa'),
                          subtitle: Text('Level'),
                        )
                      : node.data is DocumentModel
                          ? SavedViewNonExpandsionPreview(
                              documentModel: node.data,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1.5,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .shadow
                                        .withOpacity(0.1),
                                  ),
                                ),
                              ),
                              child: ListTile(
                                key: UniqueKey(),
                                title: Text(node.data.getValue('name')),
                                subtitle: Text(
                                    'Thư mục: ${node.data.getValue('child_folder_count')}  Tài liệu: ${node.data.getValue('document_count')}'),
                                leading:
                                    isLoading[node.data.getValue('checksum')] ==
                                            true
                                        ? const CircularProgressIndicator()
                                        : const Icon(Icons.folder_outlined),
                                onTap: () async {
                                  // setState(() {
                                  //   isLoading[node.data.getValue('checksum')] =
                                  //       true;
                                  // });
                                  // await context
                                  //     .read<LabelCubit>()
                                  //     .loadChildNodes(
                                  //       node,
                                  //     );

                                  if (node.data.getValue('child_folder_count') >
                                          0 ||
                                      node.data.getValue('document_count') !=
                                          0) {
                                    FolderRoute(node).push(context);
                                  }

                                  // setState(() {
                                  //   isLoading[node.data.getValue('checksum')] =
                                  //       false;
                                  // });
                                  // if (_controller!
                                  //     .elementAt(node.path)
                                  //     .expansionNotifier
                                  //     .value) {
                                  //   _controller!.toggleExpansion(node);
                                  // }
                                },
                              ),
                            ),
                );
        },
      ),
    );
  }
}

class TreeHasOnlyFolder extends StatefulWidget {
  const TreeHasOnlyFolder({
    super.key,
    required this.labelState,
    this.documentModel,
    required this.onValueChanged,
  });
  final LabelState labelState;
  final DocumentModel? documentModel;
  final Function(int? value) onValueChanged;

  @override
  State<TreeHasOnlyFolder> createState() => _TreeHasOnlyFolderState();
}

class _TreeHasOnlyFolderState extends State<TreeHasOnlyFolder> {
  TreeViewController? _controller;
  final Map<String, bool> isLoading = {};
  Map<String, bool> loading = {};
  bool _selectedRoot = false;
  int? _selectedItemId;
  int? parentFolder;

  void updateChildValue(int? newValue) {
    setState(() {
      parentFolder = newValue;
    });
    widget.onValueChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: SliverTreeView.simple(
        tree: widget.labelState.folderTree!,
        showRootNode: true,
        expansionIndicatorBuilder: (context, node) =>
            ChevronIndicator.rightDown(
          alignment: Alignment.center,
          tree: node,
          padding: const EdgeInsets.all(16),
        ),
        indentation: const Indentation(style: IndentStyle.squareJoint),
        onTreeReady: (controller) {
          _controller = controller;
        },
        builder: (context, node) {
          return node.level == 0
              ? Card(
                  color: _selectedRoot
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  child: GestureDetector(
                    onLongPress: () {
                      updateChildValue(null);
                      setState(() {
                        _controller?.toggleExpansion(node);
                        _selectedRoot = !_selectedRoot;
                      });
                    },
                    child: ListTile(
                      title: Text(S.of(context)!.chooseFolder),
                      subtitle: Text(S.of(context)!.rootFolder),
                    ),
                  ),
                )
              : node.data is Folder
                  ? Card(
                      color: widget.documentModel?.folder ==
                              node.data.getValue('id')
                          ? Theme.of(context).colorScheme.shadow
                          : node.data.getValue('id') == _selectedItemId
                              ? Theme.of(context).colorScheme.primary
                              : null,
                      child: GestureDetector(
                        onLongPress: () {
                          updateChildValue(node.data.getValue('id'));
                          setState(() {
                            _selectedItemId = node.data.getValue('id');
                            _selectedRoot = false;
                          });
                        },
                        child: ListTile(
                          key: UniqueKey(),
                          title: Text(node.data.getValue('name')),
                          subtitle: Text('Level ${node.level}'),
                          leading:
                              isLoading[node.data.getValue('checksum')] == true
                                  ? const CircularProgressIndicator()
                                  : const Icon(Icons.folder_outlined),
                          onTap: () async {
                            if (node.length != 0 &&
                                _controller!
                                    .elementAt(node.path)
                                    .expansionNotifier
                                    .value &&
                                isLoading[node.data.getValue('checksum')] !=
                                    null) {
                              _controller!.collapseNode(node);
                              return;
                            }
                            setState(() {
                              isLoading[node.data.getValue('checksum')] = true;
                            });
                            await context.read<LabelCubit>().loadChildNodes(
                                  node,
                                );

                            setState(() {
                              isLoading[node.data.getValue('checksum')] = false;
                            });
                            // if (_controller!
                            //     .elementAt(node.path)
                            //     .expansionNotifier
                            //     .value) {
                            //   _controller!.toggleExpansion(node);
                            // }
                          },
                        ),
                      ),
                    )
                  : const SizedBox();
        },
      ),
    );
  }
}

Future<void> _showPopupMenu(BuildContext context, Offset offset, Folder? folder,
    bool enable, String key, TreeNode<dynamic> node) async {
  await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      MediaQuery.of(context).size.width - offset.dx,
      MediaQuery.of(context).size.height - offset.dy,
    ),
    items: [
      PopupMenuItem(
        enabled: enable,
        child: ListTile(
          leading: const Icon(Icons.edit),
          title: Text(S.of(context)!.edit),
          onTap: () async {
            Navigator.of(context).pop(); // Close the popup menu
            final updated = await EditLabelRoute(folder!).push(context);
            if (updated != null) {
              updated is bool && updated == true
                  ? context.read<LabelCubit>().removeNodeInTree(node)
                  : context
                      .read<LabelCubit>()
                      .replaceNodeInTree(key, updated, node);
            }
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.add_circle_outline),
          title: Text(S.of(context)!.addFolder),
          onTap: () async {
            Navigator.of(context).pop();
            final createdLabel =
                await CreateLabelRoute(LabelType.folders, $extra: folder)
                    .push(context);
            if (createdLabel != null) {
              context
                  .read<LabelCubit>()
                  .addFolderToNode(key, createdLabel, node);
            }
          },
        ),
      ),
      PopupMenuItem(
          child: ListTile(
        leading: const Icon(Icons.add_circle_outline),
        title: Text('Them tai lieu moi'),
        onTap: () async {
          Navigator.of(context).pop();
          await _onUploadFromFilesystem(context, folder!.id!);
        },
      )),
    ],
  );
}

Future<void> _onUploadFromFilesystem(BuildContext context, int folderId) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions:
        supportedFileExtensions.map((e) => e.replaceAll(".", "")).toList(),
    withData: true,
    allowMultiple: false,
  );

  if (result?.files.single.path != null) {
    final path = result!.files.single.path!;
    final extension = p.extension(path);
    final filename = p.basenameWithoutExtension(path);
    File file = File(path);
    if (!supportedFileExtensions.contains(extension.toLowerCase())) {
      showErrorMessage(
        context,
        const EdocsApiException(ErrorCode.unsupportedFileFormat),
      );
      return;
    }

    DocumentUploadRoute(
      $extra: file.readAsBytesSync(),
      filename: filename,
      title: filename,
      fileExtension: extension,
      initFolderID: folderId,
    ).push<DocumentUploadResult>(context);
  }
}

class EmtyFolderTree extends StatelessWidget {
  const EmtyFolderTree({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context)!.youDidNotAnyFolderYet,
            style: Theme.of(context).textTheme.bodySmall,
          ).padded(),
          TextButton.icon(
            onPressed: () {
              CreateLabelRoute(
                LabelType.folders,
              ).push(context);
            },
            icon: const Icon(Icons.add),
            label: Text(S.of(context)!.newView),
          )
        ],
      ).paddedOnly(left: 16),
    );
  }
}

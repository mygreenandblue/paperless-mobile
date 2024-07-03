// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/extensions/flutter_extensions.dart';
import 'package:edocs_mobile/core/global/constants.dart';
import 'package:edocs_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:edocs_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:edocs_mobile/features/document_upload/view/document_upload_preparation_page.dart';
import 'package:edocs_mobile/features/labels/view/widgets/countdown.dart';
import 'package:edocs_mobile/features/saved_view_details/view/saved_view_non_Expandsion_preview.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/helpers/message_helpers.dart';
import 'package:edocs_mobile/routing/routes/folder_route.dart';
import 'package:edocs_mobile/routing/routes/labels_route.dart';
import 'package:edocs_mobile/routing/routes/scanner_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderTree extends StatefulWidget {
  const FolderTree(
      {Key? key,
      this.expandChildrenOnReady = false,
      required this.tree,
      this.name,
      this.type,
      this.folder})
      : super(key: key);

  final bool expandChildrenOnReady;
  final TreeNode<dynamic> tree;
  final String? type;
  final String? name;
  final Folder? folder;

  @override
  State<FolderTree> createState() => _FolderTreeState();
}

class _FolderTreeState extends State<FolderTree> {
  TreeViewController? _controller;
  final Map<String, bool> isLoading = {};

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LabelCubit>().state;

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
        onTreeReady: (controller) async {
          _controller = controller;
          if (widget.expandChildrenOnReady) {
            controller.expandAllChildren(widget.tree);
          }
          for (var node in widget.tree.children.values) {
            if (node.children.isNotEmpty) {
              controller.collapseNode(node as TreeNode);
            }
          }
          for (var node in widget.tree.children.values) {
            if (node.children.isNotEmpty) {
              controller.collapseNode(node as TreeNode);
            }
          }
          if (state.node != null) {
            controller.collapseNode(state.node as TreeNode);
          }
        },
        focusToNewNode: true,
        builder: (context, node) {
          return node.level == 0
              ? GestureDetector(
                  onLongPressStart: (details) {
                    showPopupMenu(
                        context,
                        details.globalPosition,
                        widget.type == 'root' ? node.data : widget.folder!,
                        widget.type == 'root' ? false : true,
                        node.key,
                        widget.type == 'root' ? node : widget.tree,
                        widget.type!,
                        _controller!);
                  },
                  child: Card(
                    child: ListTile(
                      title: widget.name != null
                          ? Text(widget.name ?? '')
                          : Text(S.of(context)!.personalMaterial),
                      subtitle: widget.name != null
                          ? Text(
                              '${S.of(context)!.folderAndFile}: ${node.length}')
                          : Text(S.of(context)!.allFileAndFolder),
                    ),
                  ),
                )
              : GestureDetector(
                  onLongPressStart: (details) {
                    if (node.data is Folder) {
                      showPopupMenu(context, details.globalPosition, node.data,
                          true, node.key, node, widget.type!, _controller!);
                    }
                  },
                  child: node.data is DocumentModel
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
                            subtitle: Text(node.length > 0
                                ? '${S.of(context)!.folderAndFile}: ${node.length}'
                                : '${S.of(context)!.folderAndFile}: ${node.data.getValue('child_folder_count') + node.data.getValue('document_count')} '),
                            leading:
                                isLoading[node.data.getValue('checksum')] ==
                                        true
                                    ? const CircularProgressIndicator()
                                    : const Icon(Icons.folder_outlined),
                            onTap: () async {
                              if (node.data.getValue('child_folder_count') >
                                      0 ||
                                  node.data.getValue('document_count') > 0 ||
                                  node.length > 0) {
                                FolderRoute(
                                  node.data,
                                  folderId: node.data.getValue('id'),
                                  folderName: node.data.getValue('name'),
                                ).push(context);
                                await context.read<LabelCubit>().loadChildNodes(
                                    node.data.getValue('id'), node);
                              }

                              if (_controller!
                                  .elementAt(node.path)
                                  .expansionNotifier
                                  .value) {
                                _controller!.toggleExpansion(node);
                              }
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
    required this.folderTree,
    this.documentModel,
    required this.onValueChanged,
  });
  final TreeNode folderTree;
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
        tree: widget.folderTree,
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
                          subtitle: Text(
                              '${S.of(context)!.folder}: ${node.data.getValue('child_folder_count')} '),
                          leading:
                              isLoading[node.data.getValue('checksum')] == true
                                  ? const CircularProgressIndicator()
                                  : const Icon(Icons.folder_outlined),
                          onTap: () async {
                            if (node.data.getValue('child_folder_count') < 0) {
                              return;
                            }
                            setState(() {
                              isLoading[node.data.getValue('checksum')] = true;
                            });
                            await context
                                .read<LabelCubit>()
                                .loadChildNodesHasOnlyFolder(
                                    node.data.getValue('id'), node);

                            setState(() {
                              isLoading[node.data.getValue('checksum')] = false;
                            });
                            if (!_controller!
                                .elementAt(node.path)
                                .expansionNotifier
                                .value) {
                              _controller!.toggleExpansion(node);
                            }
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

Future<void> showPopupMenu(
    BuildContext context,
    Offset offset,
    Folder? folder,
    bool enable,
    String key,
    TreeNode<dynamic> node,
    String type,
    TreeViewController controller) async {
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
            Navigator.of(context).pop();
            final updated = await EditLabelRoute(folder!).push(context);
            if (updated != null) {
              updated is bool && updated == true
                  ? context.read<LabelCubit>().removeNodeInTree(node)
                  : context.read<LabelCubit>().replaceDataInNode(updated, node);
            }
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.drive_folder_upload_outlined),
          title: Text(S.of(context)!.addFolder),
          onTap: () async {
            Navigator.of(context).pop();

            final createdLabel =
                await CreateLabelRoute(LabelType.folders, $extra: folder)
                    .push(context);
            if (createdLabel != null) {
              await context
                  .read<LabelCubit>()
                  .loadChildNodes(createdLabel!.parentFolder!, node);
              controller.toggleExpansion(node);
            }
          },
        ),
      ),
      PopupMenuItem(
          child: ListTile(
        leading: const Icon(Icons.file_upload_outlined),
        title: Text(S.of(context)!.upLoadFile),
        onTap: () async {
          Navigator.of(context).pop();
          await onUploadFromFilesystem(context, folder?.id);
        },
      )),
      PopupMenuItem(
          enabled: enable,
          child: ListTile(
            leading: const Icon(Icons.delete),
            title: Text(S.of(context)!.delete),
            onTap: () async {
              await _onDelete(context, folder!);
              if (node.level == 1) {
                node.remove(node);
              }

              if (node.parent != null && folder.parentFolder != null) {
                await context.read<LabelCubit>().loadChildNodes(
                    folder.parentFolder!, node.parent as TreeNode);
                node.remove(node);
              }
              controller.expandAllChildren(node.parent as TreeNode);
            },
          )),
    ],
  );
}

Future<void> _onDelete(BuildContext context, Folder folder) async {
  bool countdownComplete = false;
  if ((folder.documentCount ?? 0) > 0 || (folder.childFolderCount ?? 0) > 0) {
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(S.of(context)!.confirmDeletion),
              content: Text(
                S.of(context)!.deleteLabelWarningText,
              ),
              actions: [
                const DialogCancelButton(),
                DialogConfirmButton(
                  enable: countdownComplete ? true : false,
                  label: S.of(context)!.delete,
                  style: DialogConfirmButtonStyle.danger,
                  opacity: countdownComplete ? 1 : 0.2,
                ),
                if (countdownComplete == false)
                  CountdownWidget(
                    start: 3,
                    onCountdownComplete: () {
                      setState(() {
                        countdownComplete = true;
                      });
                    },
                  )
              ],
            );
          }),
        ) ??
        false;
    if (shouldDelete) {
      try {
        await context.read<LabelCubit>().removeFolder(folder);
      } on EdocsApiException catch (error) {
        showErrorMessage(context, error);
      } catch (error, stackTrace) {
        log("An error occurred!", error: error, stackTrace: stackTrace);
      }
      showSnackBar(
        context,
        S.of(context)!.notiActionSuccess,
      );

      context.pop();
    }
  } else {
    context.read<LabelCubit>().removeFolder(folder);
    showSnackBar(
      context,
      S.of(context)!.notiActionSuccess,
    );
    context.pop();
  }
}

Future<void> onUploadFromFilesystem(BuildContext context, int? folderId) async {
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

class EmtyFolderPage extends StatelessWidget {
  const EmtyFolderPage({super.key, this.folder, this.onAdd});
  final Folder? folder;
  final Function()? onAdd;
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
            onPressed: onAdd ?? () {},
            icon: const Icon(Icons.add),
            label: Text(S.of(context)!.addFolder),
          )
        ],
      ).paddedOnly(left: 16),
    );
  }
}

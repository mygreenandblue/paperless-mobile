// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/features/saved_view_details/view/saved_view_non_Expandsion_preview.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/routing/routes/labels_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';
import 'package:flutter/material.dart';

import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderTree extends StatefulWidget {
  const FolderTree({
    Key? key,
    required this.labelState,
    required this.controller,
    required this.isLoading,
  }) : super(key: key);
  final LabelState labelState;
  final TreeViewController controller;
  final Map<String, bool> isLoading;

  @override
  State<FolderTree> createState() => _FolderTreeState();
}

class _FolderTreeState extends State<FolderTree> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverTreeView.simple(
        tree: widget.labelState.folderTree!,
        showRootNode: true,
        expansionIndicatorBuilder: (context, node) =>
            ChevronIndicator.rightDown(
          alignment: Alignment.centerRight,
          tree: node,
          padding: const EdgeInsets.all(16),
        ),
        indentation: const Indentation(style: IndentStyle.squareJoint),
        onTreeReady: (controller) {
          controller = controller;
          // controller.expandAllChildren(widget.labelState.folderTree!);
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
                      title: Text(S.of(context)!.personalMaterial),
                      subtitle: Text(S.of(context)!.allFileAndFolder),
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
                                subtitle: Text('Level ${node.level}'),
                                leading: widget.isLoading[
                                            node.data.getValue('checksum')] ==
                                        true
                                    ? const CircularProgressIndicator()
                                    : const Icon(Icons.folder_outlined),
                                onTap: () async {
                                  if (node.length != 0 &&
                                      widget.controller
                                          .elementAt(node.path)
                                          .expansionNotifier
                                          .value &&
                                      widget.isLoading[
                                              node.data.getValue('checksum')] !=
                                          null) {
                                    widget.controller.collapseNode(node);
                                    return;
                                  }
                                  setState(() {
                                    widget.isLoading[
                                        node.data.getValue('checksum')] = true;
                                  });
                                  await context
                                      .read<LabelCubit>()
                                      .loadChildNodes(
                                        node,
                                      );

                                  setState(() {
                                    widget.isLoading[
                                        node.data.getValue('checksum')] = false;
                                  });
                                  if (widget.controller
                                      .elementAt(node.path)
                                      .expansionNotifier
                                      .value) {
                                    widget.controller.toggleExpansion(node);
                                  }
                                },
                              ),
                            ),
                );
        },
      ),
    );
  }

  Future<void> _showPopupMenu(BuildContext context, Offset offset,
      Folder? folder, bool enable, String key, TreeNode<dynamic> node) async {
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
      ],
    );
  }
}

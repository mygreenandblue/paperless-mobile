// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:edocs_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:edocs_mobile/features/labels/view/widgets/countdown.dart';
import 'package:edocs_mobile/helpers/message_helpers.dart';
import 'package:edocs_mobile/routing/routes/labels_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/features/labels/folder/folder_tree.dart';
import 'package:edocs_mobile/features/saved_view_details/view/saved_view_non_Expandsion_preview.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:edocs_mobile/routing/routes/folder_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';
import 'package:go_router/go_router.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({
    Key? key,
    required this.id,
    required this.name,
    required this.folder,
  }) : super(key: key);
  final int id;
  final String name;
  final Folder folder;

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  late Folder folder;
  List<Folder> sortedFolderList = [];
  List<DocumentModel> sortedDocumentList = [];
  bool _isPop = false;

  @override
  void initState() {
    folder = widget.folder;
    context.read<LabelCubit>().loadFileAndFolder(widget.id);
    super.initState();
    setState(() {
      _isPop = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LabelCubit>();
    final state = context.watch<LabelCubit>().state;

    if (state.childFolders[widget.id]?.name == widget.name) {
      cubit.loadFileAndFolder(widget.id);
    }
    if (_isPop) {
      cubit.loadFileAndFolder(widget.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${S.of(context)!.folder}: ${folder.name}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(true),
        ),
        actions: [_showPopupMenu(context, widget.folder, cubit, state, true)],
      ),
      body: BlocBuilder<LabelCubit, LabelState>(
        builder: (context, state) {
          return SafeArea(
            top: true,
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomScrollView(
                    slivers: [
                      state.isLoading
                          ? const SliverToBoxAdapter(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : state.folders.isEmpty && state.documents.isEmpty
                              ? const EmtyFolderPage()
                              : _buildBody(context, state.childFolders,
                                  state.documents, cubit, state),
                    ],
                  ),
          );
        },
      ),
    );
  }

  _buildBody(BuildContext context, Map<int, Folder> folders,
      Map<int, DocumentModel> documents, LabelCubit cubit, LabelState state) {
    sortedFolderList = folders.values.toList()..sort();
    sortedDocumentList = documents.values.toList();

    return folders.isNotEmpty || documents.isNotEmpty
        ? SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < sortedFolderList.length) {
                    return state.singleLoading[sortedFolderList[index].id] ==
                            true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : GestureDetector(
                            onLongPressStart: (details) {},
                            child: ListTile(
                              key: UniqueKey(),
                              title: Text(
                                  sortedFolderList[index].getValue('name')),
                              subtitle: Text(
                                  '${S.of(context)!.folderAndFile}: ${sortedFolderList[index].getValue('child_folder_count') + sortedFolderList[index].getValue('document_count')}'),
                              leading: const Icon(Icons.folder_outlined),
                              trailing: _showPopupMenu(context,
                                  sortedFolderList[index], cubit, state, false),
                              onTap: () async {
                                if (sortedFolderList[index]
                                            .getValue('child_folder_count') >
                                        0 ||
                                    sortedFolderList[index]
                                            .getValue('document_count') >
                                        0) {
                                  final isPop = await FolderRoute(
                                    sortedFolderList[index],
                                    folderId:
                                        sortedFolderList[index].getValue('id'),
                                    folderName: sortedFolderList[index]
                                        .getValue('name'),
                                  ).push(context);
                                  setState(() {
                                    _isPop = isPop;
                                  });
                                }
                              },
                            ),
                          );
                  } else {
                    int newIndex = index - sortedFolderList.length;
                    return SavedViewNonExpandsionPreview(
                      documentModel: sortedDocumentList[newIndex],
                    );
                  }
                },
                childCount: sortedFolderList.length + sortedDocumentList.length,
              ),
            ),
          )
        : EmtyFolderPage(
            folder: widget.folder,
            onAdd: () async {
              final createdLabel =
                  await CreateLabelRoute(LabelType.folders, $extra: folder)
                      .push(context);
              if (createdLabel != null) {
                cubit.updateFolder(createdLabel);
              }
            },
          );
  }

  Future<void> _onDelete(
      BuildContext context, Folder data, bool shouldPop) async {
    bool countdownComplete = false;
    if ((data.documentCount ?? 0) > 0 || (data.childFolderCount ?? 0) > 0) {
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
          await context.read<LabelCubit>().removeFolder(data);
        } on EdocsApiException catch (error) {
          showErrorMessage(context, error);
        } catch (error, stackTrace) {
          log("An error occurred!", error: error, stackTrace: stackTrace);
        }
        showSnackBar(
          context,
          S.of(context)!.notiActionSuccess,
        );

        shouldPop ? context.pop(true) : null;
      }
    } else {
      context.read<LabelCubit>().removeFolder(data);
      showSnackBar(
        context,
        S.of(context)!.notiActionSuccess,
      );
      shouldPop ? context.pop(true) : null;
    }
  }

  Widget _showPopupMenu(BuildContext context, Folder data, LabelCubit cubit,
      LabelState state, bool shouldPop) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.edit),
              const SizedBox(
                width: 4,
              ),
              Text(S.of(context)!.edit)
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              const Icon(Icons.drive_folder_upload_outlined),
              const SizedBox(
                width: 4,
              ),
              Text(S.of(context)!.addFolder)
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            children: [
              const Icon(Icons.file_upload_outlined),
              const SizedBox(
                width: 4,
              ),
              Text(S.of(context)!.upLoadFile)
            ],
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: Row(
            children: [
              const Icon(Icons.delete_outline),
              const SizedBox(
                width: 4,
              ),
              Text(S.of(context)!.delete)
            ],
          ),
        ),
      ],
      offset: const Offset(0, 50),
      elevation: 2,
      onSelected: (value) async {
        switch (value) {
          case 1:
            final updated = await EditLabelRoute(data).push(context);
            if (!shouldPop) {
              context.read<LabelCubit>().updateFolder(updated);
              context
                  .read<LabelCubit>()
                  .loadChildNodes(state.node!.data.getValue('id'), state.node!);
            }
            if (shouldPop && updated != null) {
              for (var node in state.folderTree!.children.values) {
                if (node.key == data.checksum) {
                  updated is bool && updated == true
                      ? context
                          .read<LabelCubit>()
                          .removeNodeInTree(node as TreeNode)
                      : context
                          .read<LabelCubit>()
                          .replaceDataInNode(updated, node as TreeNode);
                }
              }
              if (state.node != null) {
                for (var node in state.node!.children.values) {
                  if (node.key == data.checksum) {
                    updated is bool && updated == true
                        ? context
                            .read<LabelCubit>()
                            .removeNodeInChildNode(node as TreeNode)
                        : context
                            .read<LabelCubit>()
                            .replaceDataInNode(updated, node as TreeNode);
                  }
                }
              }
              setState(() {
                folder = updated;
              });
            }
            break;

          case 2:
            final createdLabel =
                await CreateLabelRoute(LabelType.folders, $extra: data)
                    .push(context);

            if (createdLabel != null) {
              for (var node in state.folderTree!.children.values) {
                if (node.key == data.checksum) {
                  cubit.loadChildNodes(data.id!, node as TreeNode);
                }
              }
              if (shouldPop) {
                cubit.updateFolder(createdLabel);
              } else {
                await cubit.loadAddedItemFolder(data.id!, data);
              }
            }
            break;

          case 3:
            await onUploadFromFilesystem(context, data.id);
            break;

          case 4:
            await _onDelete(context, data, shouldPop);
            state.folderTree!
                .removeWhere((element) => element.key == data.checksum);

            cubit.removeItemFolder(data.id);
            break;
        }
      },
    );
  }
}

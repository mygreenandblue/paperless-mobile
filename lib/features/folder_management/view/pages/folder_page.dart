import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:edocs_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/features/labels/folder/folder_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key, required this.tree});
  final TreeNode<dynamic> tree;

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsCubit, DocumentsState>(
        builder: (context, docState) {
      context.read<LabelCubit>().buildChildTree(widget.tree);
      return BlocBuilder<LabelCubit, LabelState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Folder: ${widget.tree.data.getValue('name')}'),
            ),
            body: SafeArea(
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
                            : state.node!.length == 0
                                ? const EmtyFolderTree()
                                : FolderTree(
                                    node: widget.tree,
                                    tree: state.node!,
                                    expandChildrenOnReady: true,
                                  )
                      ],
                    ),
            ),
          );
        },
      );
    });
  }
}

import 'package:animated_tree_view/node/node.dart';
import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/features/landing/view/widgets/folder_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_mobile/features/app_drawer/view/app_drawer.dart';
import 'package:edocs_mobile/features/document_search/view/sliver_search_bar.dart';
import 'package:edocs_mobile/features/folder_management/cubit/inbox_cubit.dart';

import 'package:edocs_mobile/generated/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key, required this.tree});
  final TreeNode<dynamic> tree;

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TreeNode treeNode = widget.tree;
    Iterable<Node> nodes = treeNode.childrenAsList;
    TreeNode rootNode = TreeNode.root();
    rootNode.addAll(nodes);

    return Scaffold(
      appBar: AppBar(
        title: Text('Folder: ${widget.tree.data.getValue('name')}'),
      ),
      body: SafeArea(
        top: true,
        child: CustomScrollView(
          slivers: [
            BlocBuilder<LabelCubit, LabelState>(
              builder: (context, lbState) {
                return lbState.isLoading
                    ? const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : rootNode.length == 0
                        ? const EmtyFolderTree()
                        : FolderTree(
                            tree: rootNode,
                            expandChildrenOnReady: true,
                          );
              },
            )
          ],
        ),
      ),
    );
  }
}

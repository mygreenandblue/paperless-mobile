import 'package:edocs_mobile/features/documents/cubit/documents_cubit.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/features/landing/view/widgets/folder_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_mobile/features/app_drawer/view/app_drawer.dart';
import 'package:edocs_mobile/features/document_search/view/sliver_search_bar.dart';

import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class FolderView extends StatefulWidget {
  const FolderView({super.key});

  @override
  State<FolderView> createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  final SliverOverlapAbsorberHandle searchBarHandle =
      SliverOverlapAbsorberHandle();

  final _nestedScrollViewKey = GlobalKey<NestedScrollViewState>();

  bool _showExtendedFab = true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nestedScrollViewKey.currentState!.innerController
          .addListener(_scrollExtentChangedListener);
    });
  }

  @override
  void dispose() {
    _nestedScrollViewKey.currentState?.innerController
        .removeListener(_scrollExtentChangedListener);
    super.dispose();
  }

  void _scrollExtentChangedListener() {
    const threshold = 400;
    final offset =
        _nestedScrollViewKey.currentState!.innerController.position.pixels;
    if (offset < threshold && _showExtendedFab == false) {
      setState(() {
        _showExtendedFab = true;
      });
    } else if (offset >= threshold && _showExtendedFab == true) {
      setState(() {
        _showExtendedFab = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: SafeArea(
        top: true,
        child: BlocBuilder<DocumentsCubit, DocumentsState>(
            builder: (context, state) {
          context.read<LabelCubit>().buildTree();
          return NestedScrollView(
            key: _nestedScrollViewKey,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverSearchBar(titleText: S.of(context)!.inbox),
            ],
            body: RefreshIndicator(
              onRefresh: () async {
                await context.read<LabelCubit>().buildTree();
              },
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
                          : lbState.folderTree!.length == 0
                              ? const EmtyFolderTree()
                              : FolderTree(
                                  tree: lbState.folderTree!,
                                  expandChildrenOnReady: true,
                                );
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

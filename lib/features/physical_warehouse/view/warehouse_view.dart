import 'package:flutter/material.dart';
import 'package:paperless_mobile/features/documents/view/widgets/sort_documents_button.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/connectivity_aware_action_wrapper.dart';
import 'package:paperless_mobile/routing/routes/shells/authenticated_route.dart';
import 'package:paperless_mobile/routing/routes/warehouse_route.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'widgets/physical_warehouse_list_item.dart';

class WarehouseView extends StatefulWidget {
  const WarehouseView({super.key});

  @override
  State<WarehouseView> createState() => _WarehouseViewState();
}

class _WarehouseViewState extends State<WarehouseView> {
  final SliverOverlapAbsorberHandle savedViewsHandle =
      SliverOverlapAbsorberHandle();
  final _nestedScrollViewKey = GlobalKey<NestedScrollViewState>();

  bool _showExtendedFab = true;

  @override
  void initState() {
    super.initState();
    // context.read<PendingTasksNotifier>().addListener(_onTasksChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nestedScrollViewKey.currentState!.innerController
          .addListener(_scrollExtentChangedListener);
    });
  }

  Future<void> _reloadData() async {}

  void _scrollExtentChangedListener() {
    const threshold = kToolbarHeight * 2;
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
  void dispose() {
    _nestedScrollViewKey.currentState?.innerController
        .removeListener(_scrollExtentChangedListener);
    // context.read<PendingTasksNotifier>().removeListener(_onTasksChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context)!.warehouse),
        ),
        floatingActionButton: ConnectivityAwareActionWrapper(
          offlineBuilder: (context, child) => const SizedBox.shrink(),
          child: FloatingActionButton.extended(
            extendedPadding: _showExtendedFab
                ? null
                : const EdgeInsets.symmetric(horizontal: 16),
            label: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    child: child,
                  ),
                );
              },
              child: _showExtendedFab
                  ? Row(
                      children: [
                        const Icon(Icons.add),
                        const SizedBox(width: 8),
                        Text(S.of(context)!.addWarehouse),
                      ],
                    )
                  : const Icon(Icons.add),
            ),
            onPressed: () =>
                CreateWarehouseRoute(action: 'create').push(context),
          ),
        ),
        body: NestedScrollView(
          key: _nestedScrollViewKey,
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: savedViewsHandle,
              sliver: SliverPinnedHeader(
                child: Material(
                  elevation: 2,
                  child: _buildViewActions(),
                ),
              ),
            ),
          ],
          body: _buildListView(context),
        ),
      ),
    );
  }

  Widget _buildViewActions() {
    return Container(
      padding: const EdgeInsets.all(4),
      color: Theme.of(context).colorScheme.background,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SortDocumentsButton(
            enabled: true,
          ),
        ],
      ),
    );
  }

  Widget _buildListView(
    BuildContext context,
  ) {
    return NotificationListener<ScrollNotification>(
      child: RefreshIndicator(
        edgeOffset: kTextTabBarHeight + 2,
        onRefresh: _reloadData,
        child: CustomScrollView(
          key: const PageStorageKey<String>("warehouse"),
          slivers: <Widget>[
            SliverOverlapInjector(handle: savedViewsHandle),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 12,
                (context, index) {
                  return PhysicalWarehouseListItem(
                      type: 'warehouse',
                      name: 'name',
                      organization: 'organization',
                      onEdit: () {
                        CreateWarehouseRoute(action: 'edit', name: 'name')
                            .push(context);
                      },
                      onDelete: () {});
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 96),
            )
          ],
        ),
      ),
    );
  }
}

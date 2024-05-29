// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbols.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/database/tables/local_user_app_state.dart';
import 'package:paperless_mobile/features/physical_warehouse/cubit/warehouse_edit/warehouse_edit_cubit.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

import 'package:sliver_tools/sliver_tools.dart';

import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/database/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/features/documents/view/widgets/sort_documents_button.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/features/physical_warehouse/cubit/warehouse_cubit/warehouse_cubit.dart';
import 'package:paperless_mobile/features/physical_warehouse/view/widgets/physical_warehouse_list_view.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/connectivity_aware_action_wrapper.dart';
import 'package:paperless_mobile/routing/routes/physical_warehouse_route.dart';
import 'package:paperless_mobile/routing/routes/shells/authenticated_route.dart';

class PhysicalWarehouseView extends StatefulWidget {
  final String type;
  const PhysicalWarehouseView({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<PhysicalWarehouseView> createState() => _PhysicalWarehouseViewState();
}

class _PhysicalWarehouseViewState extends State<PhysicalWarehouseView> {
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

  Future<void> _reloadData() async {
    try {
      await Future.wait([
        context.read<WarehouseEditCubit>().reload(),
      ]);
    } catch (error, stackTrace) {
      showGenericError(context, error, stackTrace);
    }
  }

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
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount).listenable(),
      builder: (context, box, child) {
        final currentUserId = Hive.box<GlobalSettings>(HiveBoxes.globalSettings)
            .getValue()!
            .loggedInUserId;
        final user = box.get(currentUserId)!.paperlessUser;

        return BlocConsumer<ConnectivityCubit, ConnectivityState>(
          listenWhen: (previous, current) =>
              previous != ConnectivityState.connected &&
              current == ConnectivityState.connected,
          listener: (context, state) {
            _reloadData();
          },
          builder: (context, connectivityState) {
            return SafeArea(
              top: true,
              child: Scaffold(
                appBar: AppBar(
                  title: widget.type == 'Warehouse'
                      ? Text(S.of(context)!.warehouse)
                      : widget.type == 'Shelf'
                          ? Text(S.of(context)!.shelf)
                          : Text(S.of(context)!.briefcase),
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
                                widget.type == 'Warehouse'
                                    ? Text(S.of(context)!.addWarehouse)
                                    : widget.type == 'Shelf'
                                        ? Text(S.of(context)!.addShelf)
                                        : Text(S.of(context)!.addBriefcase),
                              ],
                            )
                          : const Icon(Icons.add),
                    ),
                    onPressed: () => widget.type == 'Warehouse'
                        ? CreatePhysicalWarehouseRoute(type: widget.type)
                            .push(context)
                        : widget.type == 'Shelf'
                            ? CreatePhysicalWarehouseRoute(type: widget.type)
                                .push(context)
                            : CreatePhysicalWarehouseRoute(type: 'Boxcase')
                                .push(context),
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
                  body: BlocProvider(
                    create: (context) => WarehouseEditCubit(
                        context.read(),
                        context.read(),
                        Hive.box<LocalUserAppState>(HiveBoxes.localUserAppState)
                            .get(currentUserId)!,
                        context.read(),
                        context.read(),
                        widget.type)
                      ..initialize(),
                    child: BlocBuilder<WarehouseEditCubit, WarehouseEditState>(
                      builder: (context, state) {
                        return NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            return true;
                          },
                          child: RefreshIndicator(
                            edgeOffset: kTextTabBarHeight,
                            notificationPredicate: (notification) =>
                                connectivityState.isConnected,
                            onRefresh: () async {
                              try {
                                await context
                                    .read<WarehouseEditCubit>()
                                    .reload();
                              } catch (error, stackTrace) {
                                logger.fe(
                                    "An error ocurred while reloading "
                                    "${[
                                      "warehouse",
                                      "shelf",
                                      "briefcase",
                                      ""
                                    ]}.",
                                    error: error,
                                    stackTrace: stackTrace,
                                    className: runtimeType.toString(),
                                    methodName: 'onRefresh');
                              }
                            },
                            child: _buildListView(user, widget.type),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
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
    UserModel user,
    String type,
  ) {
    return NotificationListener<ScrollNotification>(
      child: Builder(builder: (context) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverOverlapInjector(handle: savedViewsHandle),
            BlocBuilder<WarehouseEditCubit, WarehouseEditState>(
              builder: (context, state) {
                return PhysicalWarehouseListView<WarehouseModel>(
                  type: type,
                  canEdit: user.canEditTags,
                  canAddNew: user.canCreateTags,
                  onEdit: (warehouse) {
                    EditPhysicalWarehouseRoute(warehouse, type: type)
                        .push(context);
                  },
                  emptyStateActionButtonItem: type == 'Warehouse'
                      ? S.of(context)!.addWarehouse
                      : type == 'Shelf'
                          ? S.of(context)!.addShelf
                          : S.of(context)!.addBriefcase,
                  emptyStateDescription: S.of(context)!.noTagsSetUp,
                  onAddNew: () {
                    type == 'Warehouse'
                        ? CreatePhysicalWarehouseRoute(type: type).push(context)
                        : type == 'Shelf'
                            ? CreatePhysicalWarehouseRoute(type: type)
                                .push(context)
                            : CreatePhysicalWarehouseRoute(type: type)
                                .push(context);
                  },
                  warehouses: state.warehouses,
                  canDel: user.canViewTags,
                  onDel: (warehouse) =>
                      context.read<WarehouseEditCubit>().delete(warehouse),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}

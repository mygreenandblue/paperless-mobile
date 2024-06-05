// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_cancel_button.dart';
import 'package:paperless_mobile/core/widgets/dialog_utils/dialog_confirm_button.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit.dart';
import 'package:paperless_mobile/features/labels/view/widgets/countdown.dart';
import 'package:paperless_mobile/features/labels/view/widgets/label_tab_view.dart';

import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routing/routes/labels_route.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/database/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/features/documents/view/widgets/sort_documents_button.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/connectivity_aware_action_wrapper.dart';
import 'package:paperless_mobile/routing/routes/physical_warehouse_route.dart';
import 'package:paperless_mobile/routing/routes/shells/authenticated_route.dart';

class PhysicalWarehouseView extends StatefulWidget {
  final String type;
  final String name;
  final Warehouse warehouse;
  const PhysicalWarehouseView(
      {Key? key,
      required this.type,
      required this.name,
      required this.warehouse})
      : super(key: key);

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
      _nestedScrollViewKey.currentState?.innerController
          .addListener(_scrollExtentChangedListener);
    });
  }

  void _scrollExtentChangedListener() {
    const threshold = kToolbarHeight * 2;
    final offset =
        _nestedScrollViewKey.currentState?.innerController.position.pixels;
    if (offset! < threshold && _showExtendedFab == false) {
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

        return BlocBuilder<ConnectivityCubit, ConnectivityState>(
          builder: (context, connectivityState) {
            final cubit = context.read<LabelCubit>();
            cubit.reloadDetailsWarehouse(widget.warehouse.id!);
            return BlocBuilder<LabelCubit, LabelState>(
              builder: (context, state) {
                return SafeArea(
                  top: true,
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(widget.warehouse.name),
                      actions: [
                        IconButton(
                            onPressed: () => _onDelete(context),
                            icon: const Icon(Icons.delete)),
                        const SizedBox(
                          width: 4,
                        ),
                        IconButton(
                          onPressed: () => widget.type == 'Shelf'
                              ? EditLabelRoute(
                                  widget.warehouse,
                                ).push(context)
                              : widget.type == 'Boxcase'
                                  ? EditLabelRoute(
                                      widget.warehouse,
                                    ).push(context)
                                  : EditLabelRoute(
                                      widget.warehouse,
                                    ).push(context),
                          icon: const Icon(Icons.edit),
                        )
                      ],
                    ),
                    floatingActionButton: ConnectivityAwareActionWrapper(
                      offlineBuilder: (context, child) =>
                          const SizedBox.shrink(),
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
                                      widget.type == 'Shelf'
                                          ? Text(S.of(context)!.addShelf)
                                          : Text(S.of(context)!.addBriefcase),
                                    ],
                                  )
                                : const Icon(Icons.add),
                          ),
                          onPressed: () => widget.type == 'Shelf'
                              ? CreateLabelRoute(LabelType.warehouse,
                                      $extra: widget.warehouse, type: 'Shelf')
                                  .push(context)
                              : CreateLabelRoute(LabelType.warehouse,
                                      $extra: widget.warehouse, type: 'Boxcase')
                                  .push(context)),
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
                      body: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          final metrics = notification.metrics;
                          if (metrics.maxScrollExtent == 0) {
                            return true;
                          }

                          return true;
                        },
                        child: RefreshIndicator(
                          edgeOffset: kTextTabBarHeight,
                          notificationPredicate: (notification) =>
                              connectivityState.isConnected,
                          onRefresh: () async {
                            try {
                              widget.type == 'Shelf'
                                  ? context
                                      .read<LabelCubit>()
                                      .reloadDetailsWarehouse(
                                          widget.warehouse.id)
                                  : context
                                      .read<LabelCubit>()
                                      .reloadDetailsShelf(widget.warehouse.id!);
                            } catch (error, stackTrace) {
                              logger.fe(
                                  "An error ocurred while reloading "
                                  "${["warehouses"]}.",
                                  error: error,
                                  stackTrace: stackTrace,
                                  className: runtimeType.toString(),
                                  methodName: 'onRefresh');
                            }
                          },
                          child: state.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : _buildListView(user, widget.type, state),
                        ),
                      ),
                    ),
                  ),
                );
              },
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

  Widget _buildListView(UserModel user, String type, LabelState state) {
    return NotificationListener<ScrollNotification>(
      child: Builder(
        builder: (context) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverOverlapInjector(handle: savedViewsHandle),
              LabelTabView<Warehouse>(
                labels: type == 'Shelf' ? state.shelfs : state.boxcases,
                filterBuilder: (warehouse) => DocumentFilter(
                  warehousesId: SetIdQueryParameter(id: warehouse.id!),
                ),
                canEdit: user.canEditStoragePaths,
                canAddNew: user.canCreateStoragePaths,
                emptyStateActionButtonLabel: type == 'Shelf'
                    ? S.of(context)!.addShelf
                    : S.of(context)!.addBriefcase,
                emptyStateDescription: S.of(context)!.noStoragePathsSetUp,
                onAddNew: () => type == 'Shelf'
                    ? CreateLabelRoute(
                        LabelType.warehouse,
                        type: 'Shelf',
                        $extra: widget.warehouse,
                      ).push(context)
                    : CreateLabelRoute(
                        LabelType.warehouse,
                        type: 'Boxcase',
                        $extra: widget.warehouse,
                      ).push(context),
                onEdit: (warehouse) async {
                  if (type == 'Shelf') {
                    context
                        .read<LabelCubit>()
                        .reloadDetailsShelf(warehouse.id!);
                    PhysicalWarehouseRoute(warehouse,
                            type: 'Boxcase', initialName: warehouse.name)
                        .push(context);
                  } else {
                    EditLabelRoute(
                      warehouse,
                    ).push(context);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _onDelete(BuildContext context) async {
    bool countdownComplete = false;
    if ((widget.warehouse.documentCount ?? 0) > 0) {
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
          widget.type == 'Shelf'
              ? context.read<LabelCubit>().removeShelf(widget.warehouse)
              : context.read<LabelCubit>().removeBoxcase(widget.warehouse);
        } on PaperlessApiException catch (error) {
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
      widget.warehouse.type == 'Shelf'
          ? context.read<LabelCubit>().removeShelf(widget.warehouse)
          : context.read<LabelCubit>().removeBoxcase(widget.warehouse);
      showSnackBar(
        context,
        S.of(context)!.notiActionSuccess,
      );

      context.pop();
    }
  }
}

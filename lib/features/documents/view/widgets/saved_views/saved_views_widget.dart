import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/widgets/hint_card.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/view/widgets/saved_views/saved_view_chip.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routes/typed/branches/saved_views_route.dart';

class SavedViewsWidget extends StatefulWidget {
  final void Function(SavedView view) onViewSelected;
  final void Function(SavedView view) onUpdateView;
  final void Function(SavedView view) onDeleteView;

  final DocumentFilter filter;
  final ExpansionTileController? controller;

  const SavedViewsWidget({
    super.key,
    required this.onViewSelected,
    required this.filter,
    required this.onUpdateView,
    required this.onDeleteView,
    this.controller,
  });

  @override
  State<SavedViewsWidget> createState() => _SavedViewsWidgetState();
}

class _SavedViewsWidgetState extends State<SavedViewsWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = _animationController.drive(Tween(begin: 0, end: 0.5));
  }

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: PageStorageBucket(),
      child: ExpansionTile(
        controller: widget.controller,
        tilePadding: const EdgeInsets.only(left: 8),
        trailing: RotationTransition(
          turns: _animation,
          child: const Icon(Icons.expand_more),
        ).paddedOnly(right: 8),
        onExpansionChanged: (isExpanded) {
          if (isExpanded) {
            _animationController.forward();
          } else {
            _animationController.reverse().then((value) => setState(() {}));
          }
        },
        title: Text(
          S.of(context)!.views,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        leading: Icon(
          Icons.saved_search,
          color: Theme.of(context).colorScheme.primary,
        ).padded(),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<SavedViewCubit, SavedViewState>(
            builder: (context, state) {
              return state.map(
                initial: (_) => const Placeholder(),
                loading: (_) => const Placeholder(),
                loaded: (value) {
                  if (value.savedViews.isEmpty) {
                    return Text(S.of(context)!.noItemsFound)
                        .paddedOnly(left: 16);
                  }
                  return Container(
                    margin: EdgeInsets.only(top: 16),
                    height: kMinInteractiveDimension,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) => true,
                      child: CustomScrollView(
                        scrollDirection: Axis.horizontal,
                        slivers: [
                          const SliverToBoxAdapter(
                            child: SizedBox(width: 12),
                          ),
                          SliverList.separated(
                            itemBuilder: (context, index) {
                              final view =
                                  value.savedViews.values.elementAt(index);
                              final isSelected =
                                  (widget.filter.selectedView ?? -1) == view.id;
                              return SavedViewChip(
                                view: view,
                                onViewSelected: widget.onViewSelected,
                                selected: isSelected,
                                hasChanged: isSelected &&
                                    view.toDocumentFilter() != widget.filter,
                                onUpdateView: widget.onUpdateView,
                                onDeleteView: widget.onDeleteView,
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 8),
                            itemCount: value.savedViews.length,
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(width: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                error: (_) => const Placeholder(),
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Tooltip(
              message: "Create from current filter", //TODO: INTL
              child: TextButton.icon(
                onPressed: () {
                  CreateSavedViewRoute(widget.filter).push(context);
                },
                icon: const Icon(Icons.add),
                label: Text(S.of(context)!.newView),
              ),
            ).padded(4),
          ),
        ],
      ),
    );
  }
}

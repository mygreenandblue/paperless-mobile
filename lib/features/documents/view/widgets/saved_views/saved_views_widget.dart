import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/documents/view/widgets/saved_views/saved_view_chip.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_cubit.dart';

class SavedViewsWidget extends StatelessWidget {
  final void Function(SavedView view) onViewSelected;
  final void Function(SavedView view) onUpdateView;
  final DocumentFilter filter;
  const SavedViewsWidget({
    super.key,
    required this.onViewSelected,
    required this.filter,
    required this.onUpdateView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 12,
        left: 16,
        right: 16,
      ),
      height: 50,
      child: BlocBuilder<SavedViewCubit, SavedViewState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (savedViews) {
              if (savedViews.isEmpty) {
                return Text("No saved views");
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final view = savedViews.values.elementAt(index);
                  return SavedViewChip(
                    view: view,
                    onUpdateView: onUpdateView,
                    onViewSelected: onViewSelected,
                    selected: filter.selectedView != null &&
                        view.id == filter.selectedView,
                    hasChanged: filter.selectedView == view.id &&
                        filter != view.toDocumentFilter(),
                  );
                },
                itemCount: savedViews.length,
              );
            },
            error: () => Text("Error loading saved views"),
            orElse: () => Placeholder(),
          );
        },
      ),
    );
  }
}

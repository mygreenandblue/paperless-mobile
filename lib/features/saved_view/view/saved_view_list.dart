import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/widgets/hint_card.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/documents/bloc/documents_cubit.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_cubit.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_details_cubit.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_state.dart';
import 'package:paperless_mobile/features/saved_view/view/saved_view_page.dart';
import 'package:paperless_mobile/generated/l10n.dart';

class SavedViewList extends StatelessWidget {
  const SavedViewList({super.key});

  @override
  Widget build(BuildContext context) {
    final savedViewCubit = context.read<SavedViewCubit>();
    return BlocBuilder<SavedViewCubit, SavedViewState>(
      builder: (context, state) {
        if (state.value.isEmpty) {
          return SliverToBoxAdapter(
            child: HintCard(
              hintText: S.of(context).savedViewsEmptyStateText,
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final view = state.value.values.elementAt(index);
              return ListTile(
                title: Text(view.name),
                subtitle: Text(
                  S
                      .of(context)
                      .savedViewsFiltersSetCount(view.filterRules.length),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => SavedViewDetailsCubit(
                              context.read(),
                              savedView: view,
                            ),
                          ),
                        ],
                        child: SavedViewPage(
                          onDelete: savedViewCubit.remove,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            childCount: state.value.length,
          ),
        );
      },
    );
  }
}

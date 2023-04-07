import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/bloc/connectivity_cubit.dart';
import 'package:paperless_mobile/core/widgets/hint_card.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_cubit.dart';
import 'package:paperless_mobile/features/saved_view_details/cubit/saved_view_details_cubit.dart';
import 'package:paperless_mobile/features/saved_view_details/view/saved_view_details_page.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class SavedViewList extends StatelessWidget {
  const SavedViewList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, connectivity) {
        return BlocBuilder<SavedViewCubit, SavedViewState>(
          builder: (context, state) {
            return state.when(
              initial: (correspondents, documentTypes, tags, storagePaths) =>
                  Container(),
              loading: (correspondents, documentTypes, tags, storagePaths) =>
                  Center(
                child: Text("Saved views loading..."),
              ),
              loaded: (
                savedViews,
                correspondents,
                documentTypes,
                tags,
                storagePaths,
              ) {
                if (savedViews.isEmpty) {
                  return SliverToBoxAdapter(
                    child: HintCard(
                      hintText: S
                          .of(context)!
                          .createViewsToQuicklyFilterYourDocuments,
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final view = savedViews.values.elementAt(index);
                      return ListTile(
                        enabled: connectivity.isConnected,
                        title: Text(view.name),
                        subtitle: Text(
                          S.of(context)!.nFiltersSet(view.filterRules.length),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctxt) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => SavedViewDetailsCubit(
                                      ctxt.read(),
                                      ctxt.read(),
                                      context.read(),
                                      savedView: view,
                                    ),
                                  ),
                                ],
                                child: SavedViewDetailsPage(
                                  onDelete:
                                      context.read<SavedViewCubit>().remove,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: savedViews.length,
                  ),
                );
              },
              error: (
                correspondents,
                documentTypes,
                tags,
                storagePaths,
              ) =>
                  Center(
                child: Text(
                  "An error occurred while trying to load the saved views.",
                ),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/app_drawer/view/app_drawer.dart';
import 'package:paperless_mobile/features/document_search/view/sliver_search_bar.dart';
import 'package:paperless_mobile/features/landing/view/widgets/expansion_card.dart';
import 'package:paperless_mobile/features/landing/view/widgets/mime_types_pie_chart.dart';
import 'package:paperless_mobile/features/saved_view/cubit/saved_view_cubit.dart';
import 'package:paperless_mobile/features/saved_view_details/view/saved_view_details_preview.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/routes/routes.dart';
import 'package:paperless_mobile/routes/typed/branches/documents_route.dart';
import 'package:paperless_mobile/routes/typed/branches/inbox_route.dart';
import 'package:fl_chart/fl_chart.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _searchBarHandle = SliverOverlapAbsorberHandle();
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<LocalUserAccount>().paperlessUser;
    return SafeArea(
      child: Scaffold(
        drawer: const AppDrawer(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: _searchBarHandle,
              sliver: SliverSearchBar(
                floating: true,
                titleText: S.of(context)!.documents,
              ),
            ),
          ],
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Text(
                  "Welcome to Paperless Mobile, ${currentUser.fullName ?? currentUser.username}!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontSize: 28),
                ).padded(24),
              ),
              SliverToBoxAdapter(child: _buildStatisticsCard(context)),
              BlocBuilder<SavedViewCubit, SavedViewState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loaded: (savedViews) {
                      return SliverList.builder(
                        itemBuilder: (context, index) {
                          return SavedViewDetailsPreview(
                            savedView: savedViews.values.elementAt(index),
                          );
                        },
                        itemCount: savedViews.length,
                      );
                    },
                    orElse: () => const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context) {
    return FutureBuilder<PaperlessServerStatisticsModel>(
      future: context.read<PaperlessServerStatsApi>().getServerStatistics(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Statistics", //TODO: INTL
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            ).padded(16),
          );
        }
        final stats = snapshot.data!;
        return ExpansionCard(
          title: Text(
            "Statistics", //TODO: INTL
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: ListTile(
                  shape: Theme.of(context).cardTheme.shape,
                  titleTextStyle: Theme.of(context).textTheme.labelLarge,
                  title: Text("Documents in inbox:"),
                  onTap: () {
                    InboxRoute().go(context);
                  },
                  trailing: Chip(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    labelPadding: EdgeInsets.symmetric(horizontal: 4),
                    label: Text(
                      stats.documentsInInbox.toString(),
                    ),
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: ListTile(
                  shape: Theme.of(context).cardTheme.shape,
                  titleTextStyle: Theme.of(context).textTheme.labelLarge,
                  title: Text("Total documents:"),
                  onTap: () {
                    DocumentsRoute().go(context);
                  },
                  trailing: Chip(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    labelPadding: EdgeInsets.symmetric(horizontal: 4),
                    label: Text(
                      stats.documentsTotal.toString(),
                    ),
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: ListTile(
                  shape: Theme.of(context).cardTheme.shape,
                  titleTextStyle: Theme.of(context).textTheme.labelLarge,
                  title: Text("Total characters:"),
                  trailing: Chip(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    labelPadding: EdgeInsets.symmetric(horizontal: 4),
                    label: Text(
                      stats.totalChars.toString(),
                    ),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 1.3,
                child: SizedBox(
                  width: 300,
                  child: MimeTypesPieChart(statistics: stats),
                ),
              ),
            ],
          ).padded(16),
        );
      },
    );
  }
}

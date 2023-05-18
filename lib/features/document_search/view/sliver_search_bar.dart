import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/core/database/tables/local_user_app_state.dart';
import 'package:paperless_mobile/core/delegate/customizable_sliver_persistent_header_delegate.dart';
import 'package:paperless_mobile/core/navigation/push_routes.dart';
import 'package:paperless_mobile/core/widgets/material/search/m3_search_bar.dart' as s;
import 'package:paperless_mobile/features/document_search/cubit/document_search_cubit.dart';
import 'package:paperless_mobile/features/document_search/view/document_search_bar.dart';
import 'package:paperless_mobile/features/home/view/model/api_version.dart';
import 'package:paperless_mobile/features/settings/view/manage_accounts_page.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:paperless_mobile/features/settings/view/widgets/user_avatar.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SliverSearchBar extends StatelessWidget {
  final bool floating;
  final bool pinned;
  const SliverSearchBar({
    super.key,
    this.floating = false,
    this.pinned = false,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Hive.box<GlobalSettings>(HiveBoxes.globalSettings).getValue()!.currentLoggedInUser;
    return SliverPersistentHeader(
      floating: floating,
      pinned: pinned,
      delegate: CustomizableSliverPersistentHeaderDelegate(
        minExtent: kToolbarHeight,
        maxExtent: kToolbarHeight,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocProvider(
            create: (context) => DocumentSearchCubit(
              context.read(),
              context.read(),
              context.read(),
              Hive.box<LocalUserAppState>(HiveBoxes.localUserAppState).get(currentUser)!,
            ),
            child: const DocumentSearchBar(),
          ),
        ),
      ),
    );
  }

  s.SearchBar _buildOld(BuildContext context) {
    return s.SearchBar(
      height: kToolbarHeight,
      supportingText: S.of(context)!.searchDocuments,
      onTap: () => pushDocumentSearchPage(context),
      leadingIcon: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: Scaffold.of(context).openDrawer,
      ),
      trailingIcon: IconButton(
        icon: GlobalSettingsBuilder(
          builder: (context, settings) {
            return ValueListenableBuilder(
              valueListenable: Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount).listenable(),
              builder: (context, box, _) {
                final account = box.get(settings.currentLoggedInUser!)!;
                return UserAvatar(
                  userId: settings.currentLoggedInUser!,
                  account: account,
                );
              },
            );
          },
        ),
        onPressed: () {
          final apiVersion = context.read<ApiVersion>();
          showDialog(
            context: context,
            builder: (context) => Provider.value(
              value: apiVersion,
              child: const ManageAccountsPage(),
            ),
          );
        },
      ),
    );
  }
}

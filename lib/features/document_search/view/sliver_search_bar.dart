import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/core/database/tables/local_user_account.dart';
import 'package:paperless_mobile/features/document_search/view/document_search_bar.dart';
import 'package:paperless_mobile/features/home/view/model/api_version.dart';
import 'package:paperless_mobile/features/settings/view/manage_accounts_page.dart';
import 'package:paperless_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:paperless_mobile/features/settings/view/widgets/user_avatar.dart';
import 'package:provider/provider.dart';

class SliverSearchBar extends StatelessWidget {
  final bool floating;
  final bool pinned;
  final String titleText;
  const SliverSearchBar({
    super.key,
    this.floating = false,
    this.pinned = false,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    if (LocalUserAccount.current.paperlessUser.canViewDocuments) {
      return SliverAppBar(
        toolbarHeight: kToolbarHeight,
        flexibleSpace: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const DocumentSearchBar(),
        ),
        automaticallyImplyLeading: false,
      );
    } else {
      return SliverAppBar(
        title: Text(titleText),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              padding: const EdgeInsets.all(6),
              icon: GlobalSettingsBuilder(
                builder: (context, settings) {
                  return ValueListenableBuilder(
                    valueListenable:
                        Hive.box<LocalUserAccount>(HiveBoxes.localUserAccount)
                            .listenable(),
                    builder: (context, box, _) {
                      final account = box.get(settings.currentLoggedInUser!)!;
                      return UserAvatar(account: account);
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
          ),
        ],
      );
    }
  }
}

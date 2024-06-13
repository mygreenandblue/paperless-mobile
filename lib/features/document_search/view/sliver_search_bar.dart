import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/database/hive/hive_config.dart';
import 'package:edocs_mobile/core/database/tables/local_user_account.dart';
import 'package:edocs_mobile/features/document_search/view/document_search_bar.dart';
import 'package:edocs_mobile/features/settings/view/manage_accounts_page.dart';
import 'package:edocs_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:edocs_mobile/features/settings/view/widgets/user_avatar.dart';
import 'package:provider/provider.dart';

class SliverSearchBar extends StatelessWidget {
  final bool pinned;
  final String titleText;
  const SliverSearchBar({
    super.key,
    this.pinned = false,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    if (context.watch<LocalUserAccount>().edocsUser.canViewDocuments) {
      return const SliverAppBar(
        titleSpacing: 8,
        automaticallyImplyLeading: false,
        title: DocumentSearchBar(),
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
                      final account = box.get(settings.loggedInUserId!)!;
                      return UserAvatar(account: account);
                    },
                  );
                },
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => Provider.value(
                    value: context.read<LocalUserAccount>(),
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

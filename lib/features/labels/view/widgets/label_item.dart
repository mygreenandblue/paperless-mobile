import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/config/hive/hive_config.dart';
import 'package:paperless_mobile/features/linked_documents/cubit/linked_documents_cubit.dart';
import 'package:paperless_mobile/features/linked_documents/view/linked_documents_page.dart';
import 'package:paperless_mobile/core/database/tables/user_account.dart';
import 'package:paperless_mobile/core/database/tables/global_settings.dart';
import 'package:paperless_mobile/helpers/format_helpers.dart';

class LabelItem<T extends Label> extends StatelessWidget {
  final T label;
  final String name;
  final Widget content;
  final void Function(T) onOpenEditPage;
  final DocumentFilter Function(T) filterBuilder;
  final Widget? leading;

  const LabelItem({
    super.key,
    required this.name,
    required this.content,
    required this.onOpenEditPage,
    required this.filterBuilder,
    this.leading,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: content,
      leading: leading,
      onTap: () => onOpenEditPage(label),
      trailing: _buildReferencedDocumentsWidget(context),
      isThreeLine: true,
    );
  }

  Widget _buildReferencedDocumentsWidget(BuildContext context) {
    return TextButton.icon(
      label: const Icon(Icons.link),
      icon: Text(formatMaxCount(label.documentCount)),
      onPressed: (label.documentCount ?? 0) == 0
          ? null
          : () {
              final currentUser = Hive.box<GlobalSettings>(HiveBoxes.globalSettings)
                  .getValue()!
                  .currentLoggedInUser!;
              final filter = filterBuilder(label);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => LinkedDocumentsCubit(
                      filter,
                      context.read(),
                      context.read(),
                      context.read(),
                      Hive.box<UserAccount>(HiveBoxes.userAccount).get(currentUser)!,
                    ),
                    child: const LinkedDocumentsPage(),
                  ),
                ),
              );
            },
    );
  }
}

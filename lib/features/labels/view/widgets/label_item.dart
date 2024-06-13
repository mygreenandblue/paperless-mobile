import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/database/tables/local_user_account.dart';
import 'package:edocs_mobile/helpers/format_helpers.dart';
import 'package:edocs_mobile/routing/routes/labels_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';

class LabelItem<T extends Label> extends StatelessWidget {
  final T label;
  final String name;
  final Widget content;
  final void Function(T)? onOpenEditPage;
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
      onTap: onOpenEditPage != null ? () => onOpenEditPage!(label) : null,
      trailing: _buildReferencedDocumentsWidget(context),
      isThreeLine: true,
    );
  }

  Widget _buildReferencedDocumentsWidget(BuildContext context) {
    final canOpen = (label.documentCount ?? 0) > 0 &&
        context.watch<LocalUserAccount>().edocsUser.canViewDocuments;
    return TextButton.icon(
      label: const Icon(Icons.link),
      icon: Text(formatMaxCount(label.documentCount)),
      onPressed: canOpen
          ? () {
              final filter = filterBuilder(label);
              LinkedDocumentsRoute(filter).push(context);
            }
          : null,
    );
  }
}

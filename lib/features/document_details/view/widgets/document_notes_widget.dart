import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class DocumentNotesWidget extends StatelessWidget {
  final DocumentModel document;
  const DocumentNotesWidget({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverList.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final note = document.notes.elementAt(index);
            return Card(
              // borderRadius: BorderRadius.circular(8),
              // elevation: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (note.created != null)
                    Text(
                      DateFormat.yMMMd(
                              Localizations.localeOf(context).toString())
                          .addPattern('\u2014')
                          .add_jm()
                          .format(note.created!),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(.5),
                          ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    note.note!,
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Push edit page
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context.read<DocumentDetailsCubit>().deleteNote(note);
                          showSnackBar(
                            context,
                            S.of(context)!.documentSuccessfullyUpdated,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ).padded(16),
            );
          },
          itemCount: document.notes.length,
        ),
      ],
    );
  }
}

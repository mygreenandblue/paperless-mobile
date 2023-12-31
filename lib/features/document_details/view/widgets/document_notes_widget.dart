import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/document_details/cubit/document_details_cubit.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';

class DocumentNotesWidget extends StatefulWidget {
  final DocumentModel document;
  const DocumentNotesWidget({super.key, required this.document});

  @override
  State<DocumentNotesWidget> createState() => _DocumentNotesWidgetState();
}

class _DocumentNotesWidgetState extends State<DocumentNotesWidget> {
  final _noteContentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _noteContentController,
                  maxLines: null,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return S.of(context)!.thisFieldIsRequired;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Your note here...',
                    labelText: 'New note',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ).padded(),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    icon: Icon(Icons.note_add_outlined),
                    label: Text("Add note"),
                    onPressed: () {
                      _formKey.currentState?.save();
                      if (_formKey.currentState?.validate() ?? false) {
                        context
                            .read<DocumentDetailsCubit>()
                            .addNote(_noteContentController.text);
                      }
                    },
                  ).padded(),
                ),
              ],
            ).padded(),
          ),
        ),
        SliverList.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final note = widget.document.notes.elementAt(index);
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
          itemCount: widget.document.notes.length,
        ),
      ],
    );
  }
}

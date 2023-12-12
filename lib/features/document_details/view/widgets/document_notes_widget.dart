import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:paperless_api/paperless_api.dart';

class DocumentNotesWidget extends StatelessWidget {
  final DocumentModel document;
  const DocumentNotesWidget({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, index) {
        final note = document.notes.elementAt(index);
        return ListTile(
          title: Text(note.note),
          subtitle: Text(
              DateFormat.yMMMd(Localizations.localeOf(context).toString())
                  .format(note.created)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        );
      },
      itemCount: document.notes.length,
    );
  }
}

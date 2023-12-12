import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class AddNotePage extends StatefulWidget {
  final DocumentModel document;

  const AddNotePage({super.key, required this.document});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.addNote),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: S.of(context)!.content,
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(S.of(context)!.save),
          ),
        ],
      ),
    );
  }
}

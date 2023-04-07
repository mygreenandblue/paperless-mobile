import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';

class BulkEditPage<T extends Label> extends StatefulWidget {
  final bool enableMultipleChoice;
  final Map<int, T> availableOptions;

  const BulkEditPage({
    super.key,
    required this.enableMultipleChoice,
    required this.availableOptions,
  });

  @override
  State<BulkEditPage> createState() => _BulkEditPageState();
}

class _BulkEditPageState extends State<BulkEditPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

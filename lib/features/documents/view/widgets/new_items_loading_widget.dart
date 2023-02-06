import 'package:flutter/material.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';

class NewItemsLoadingWidget extends StatelessWidget {
  const NewItemsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const CircularProgressIndicator().padded());
  }
}

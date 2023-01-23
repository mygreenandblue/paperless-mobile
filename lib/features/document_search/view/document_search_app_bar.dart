import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/widgets/material/search/m3_search.dart';
import 'package:paperless_mobile/features/document_search/cubit/document_search_cubit.dart';
import 'package:paperless_mobile/features/document_search/document_search_delegate.dart';
import 'package:provider/provider.dart';

class DocumentSearchAppBar extends StatelessWidget {
  const DocumentSearchAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: () => showMaterial3Search(
        context: context,
        delegate: DocumentSearchDelegate(
          DocumentSearchCubit(context.read()),
          searchFieldStyle: Theme.of(context).textTheme.bodyLarge,
          hintText: "Search documents",
        ),
      ),
      readOnly: true,
      decoration: InputDecoration(
        hintText: "Search documents",
        hintStyle: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(56),
          borderSide: BorderSide.none,
        ),
        prefixIcon: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        constraints: const BoxConstraints(maxHeight: 48),
      ),
      // title: Text(
      // "${S.of(context).documentsPageTitle} (${_formatDocumentCount(state.count)})",
      // ),
    );
  }
}

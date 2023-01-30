import 'package:flutter/material.dart';
import 'package:paperless_mobile/core/widgets/material/search/m3_search_bar.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';

typedef OpenSearchCallback = void Function(BuildContext context);

class SearchAppBar extends StatefulWidget with PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final OpenSearchCallback onOpenSearch;
  final Color? backgroundColor;
  const SearchAppBar({
    super.key,
    required this.onOpenSearch,
    this.bottom,
    this.backgroundColor,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: true,
      backgroundColor: widget.backgroundColor,
      title: SearchBar(
        height: kToolbarHeight - 8,
        supportingText: "Search documents",
        onTap: () => widget.onOpenSearch(context),
        leadingIcon: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        trailingIcon: IconButton(
          icon: const CircleAvatar(
            child: Text("A"),
          ),
          onPressed: () {},
        ),
      ).paddedOnly(top: 4, bottom: 4),
      bottom: widget.bottom,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/bloc/paperless_server_information_cubit.dart';
import 'package:paperless_mobile/core/bloc/paperless_server_information_state.dart';
import 'package:paperless_mobile/core/widgets/material/search/m3_search_bar.dart';
import 'package:paperless_mobile/extensions/flutter_extensions.dart';
import 'package:paperless_mobile/features/settings/view/dialogs/account_settings_dialog.dart';

typedef OpenSearchCallback = void Function(BuildContext context);

class SearchAppBar extends StatefulWidget with PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final OpenSearchCallback onOpenSearch;
  final Color? backgroundColor;
  final String hintText;
  const SearchAppBar({
    super.key,
    required this.onOpenSearch,
    this.bottom,
    this.backgroundColor,
    required this.hintText,
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
      automaticallyImplyLeading: false,
      backgroundColor: widget.backgroundColor,
      title: SearchBar(
        height: kToolbarHeight - 12,
        supportingText: widget.hintText,
        onTap: () => widget.onOpenSearch(context),
        leadingIcon: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: Scaffold.of(context).openDrawer,
        ),
        trailingIcon: IconButton(
          icon: BlocBuilder<PaperlessServerInformationCubit,
              PaperlessServerInformationState>(
            builder: (context, state) {
              return CircleAvatar(
                child: Text(state.information?.userInitials ?? ''),
              );
            },
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AccountSettingsDialog(),
            );
          },
        ),
      ).paddedOnly(top: 8, bottom: 4),
      bottom: widget.bottom,
    );
  }
}

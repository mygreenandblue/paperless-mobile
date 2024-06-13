import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_mobile/features/inbox/cubit/inbox_cubit.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class InboxEmptyWidget extends StatelessWidget {
  const InboxEmptyWidget({
    Key? key,
    required GlobalKey<RefreshIndicatorState> emptyStateRefreshIndicatorKey,
  })  : _emptyStateRefreshIndicatorKey = emptyStateRefreshIndicatorKey,
        super(key: key);

  final GlobalKey<RefreshIndicatorState> _emptyStateRefreshIndicatorKey;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _emptyStateRefreshIndicatorKey,
      onRefresh: () => context.read<InboxCubit>().loadInbox(),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(S.of(context)!.youDoNotHaveUnseenDocuments),
            TextButton(
              onPressed: () =>
                  _emptyStateRefreshIndicatorKey.currentState?.show(),
              child: Text(S.of(context)!.refresh),
            ),
          ],
        ),
      ),
    );
  }
}

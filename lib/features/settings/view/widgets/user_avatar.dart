import 'package:flutter/material.dart';
import 'package:paperless_mobile/features/login/model/user_account.dart';

class UserAvatar extends StatelessWidget {
  final String userId;
  final UserAccount account;
  const UserAvatar({
    super.key,
    required this.userId,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.primaries[userId.hashCode % Colors.primaries.length];
    final foregroundColor = backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return CircleAvatar(
      child: Text((account.fullName ?? account.username)
          .split(" ")
          .take(2)
          .map((e) => e.substring(0, 1))
          .map((e) => e.toUpperCase())
          .join("")),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SwitchingAccountsPage extends StatelessWidget {
  const SwitchingAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        child: Center(
          child: Text("Switching accounts. Please wait..."),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text("Switching accounts. Please wait..."),
            ],
          ),
        ),
      ),
    );
  }
}

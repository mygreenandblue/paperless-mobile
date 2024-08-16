import 'package:edocs_mobile/features/login/cubit/authentication_cubit.dart';
import 'package:edocs_mobile/routing/routes/asynchronous_setting_route.dart';
import 'package:edocs_mobile/routing/routes/shells/authenticated_route.dart';
import 'package:flutter/material.dart';
import 'package:edocs_mobile/features/settings/view/widgets/global_settings_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SynchronousSetting extends StatefulWidget {
  const SynchronousSetting({super.key});

  @override
  State<SynchronousSetting> createState() => _SynchronousSettingState();
}

class _SynchronousSettingState extends State<SynchronousSetting> {
  String initPath = 'C:/';
  @override
  Widget build(BuildContext context) {
    return GlobalSettingsBuilder(
      builder: (context, settings) {
        return ListTile(
            title: const Text('Cài đặt đồng bộ'),
            subtitle: Text(initPath),
            onTap: () async {
              final path =
                  await SynchronousSettingRoute(directory: 'C:/').push(context);
              if (path != null) {
                setState(() {
                  initPath = path;
                });
              }
              // await context.read<AuthenticationCubit>().updatePathPC(path);
              // print(path);
            });
      },
    );
  }
}

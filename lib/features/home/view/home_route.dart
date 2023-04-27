import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/core/bloc/server_information_cubit.dart';
import 'package:paperless_mobile/features/home/view/home_page.dart';
import 'package:paperless_mobile/features/tasks/cubit/task_status_cubit.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskStatusCubit(
            context.read(),
          ),
        ),
        BlocProvider<ServerInformationCubit>(
          create: (context) => ServerInformationCubit(
            context.read(),
          )..updateInformation(),
        ),
      ],
      child: HomePage(),
    );
  }
}

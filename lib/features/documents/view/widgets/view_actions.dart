import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_mobile/features/documents/view/widgets/sort_documents_button.dart';
import 'package:paperless_mobile/features/settings/bloc/application_settings_cubit.dart';
import 'package:paperless_mobile/features/settings/bloc/application_settings_state.dart';
import 'package:paperless_mobile/features/settings/model/view_type.dart';

class ViewActions extends StatelessWidget {
  const ViewActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SortDocumentsButton(),
        BlocBuilder<ApplicationSettingsCubit, ApplicationSettingsState>(
          builder: (context, settings) {
            final cubit = context.read<ApplicationSettingsCubit>();
            switch (settings.preferredViewType) {
              case ViewType.grid:
                return IconButton(
                  icon: const Icon(Icons.list),
                  onPressed: () =>
                      cubit.setViewType(settings.preferredViewType.toggle()),
                );
              case ViewType.list:
                return IconButton(
                  icon: const Icon(Icons.grid_view_rounded),
                  onPressed: () =>
                      cubit.setViewType(settings.preferredViewType.toggle()),
                );
            }
          },
        )
      ],
    );
  }
}

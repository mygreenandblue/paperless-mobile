import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/bloc/connectivity_cubit.dart';
import 'package:edocs_mobile/core/database/tables/local_user_account.dart';
import 'package:edocs_mobile/features/edit_label/view/edit_label_page.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class EditFolderPage extends StatelessWidget {
  final Folder folder;
  const EditFolderPage({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) {
        return LabelCubit(
          context.read(),
        );
      },
      child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
          builder: (context, cennected) {
        context.read<LabelCubit>().buildTree();

        return BlocBuilder<LabelCubit, LabelState>(builder: (context, state) {
          return state.isLoading
              ? Scaffold(
                  appBar: AppBar(
                    title: Text(S.of(context)!.edit),
                  ),
                  body: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : EditLabelPage<Folder>(
                  label: folder,
                  fromJsonT: Folder.fromJson,
                  onSubmit: (context, label) =>
                      context.read<LabelCubit>().replaceFolder(label),
                  onDelete: (context, label) =>
                      context.read<LabelCubit>().removeFolder(label),
                  canDelete: context
                      .watch<LocalUserAccount>()
                      .edocsUser
                      .canDeleteDocuments,
                  type: 'Folder',
                  parentFolder: folder.parentFolder,
                );
        });
      }),
    );
  }
}

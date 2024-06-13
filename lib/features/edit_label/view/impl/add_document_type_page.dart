import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/features/edit_label/view/add_label_page.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class AddDocumentTypePage extends StatelessWidget {
  final String? initialName;
  const AddDocumentTypePage({
    super.key,
    this.initialName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LabelCubit(
        context.read(),
      ),
      child: AddLabelPage<DocumentType>(
        pageTitle: Text(S.of(context)!.addDocumentType),
        fromJsonT: DocumentType.fromJson,
        initialName: initialName,
        onSubmit: (context, label) =>
            context.read<LabelCubit>().addDocumentType(label),
      ),
    );
  }
}

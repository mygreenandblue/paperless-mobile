import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/widgets/form_builder_fields/form_builder_color_picker.dart';
import 'package:edocs_mobile/features/edit_label/view/add_label_page.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class AddTagPage extends StatelessWidget {
  final String? initialName;
  const AddTagPage({Key? key, this.initialName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LabelCubit(
        context.read(),
      ),
      child: AddLabelPage<Tag>(
        pageTitle: Text(S.of(context)!.addTag),
        fromJsonT: Tag.fromJson,
        initialName: initialName,
        onSubmit: (context, label) => context.read<LabelCubit>().addTag(label),
        additionalFields: [
          FormBuilderColorPickerField(
            name: Tag.colorKey,
            valueTransformer: (color) => "#${color?.value.toRadixString(16)}",
            decoration: InputDecoration(
              label: Text(S.of(context)!.color),
            ),
            colorPickerType: ColorPickerType.materialPicker,
            initialValue: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0),
            readOnly: true,
          ),
          FormBuilderField<bool>(
            name: Tag.isInboxTagKey,
            initialValue: false,
            builder: (field) {
              return CheckboxListTile(
                value: field.value,
                title: Text(S.of(context)!.inboxTag),
                onChanged: (value) => field.didChange(value),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/features/edit_label/view/add_label_page.dart';
import 'package:edocs_mobile/features/labels/cubit/label_cubit.dart';
import 'package:edocs_mobile/generated/l10n/app_localizations.dart';

class AddWarehousePage extends StatelessWidget {
  final String? initialName;
  final String? type;
  final Label? label;

  const AddWarehousePage({Key? key, this.initialName, this.type, this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LabelCubit(
        context.read(),
      ),
      child: BlocBuilder<LabelCubit, LabelState>(
        builder: (context, state) {
          return AddLabelPage<Warehouse>(
            pageTitle: type == 'Warehouse'
                ? Text(S.of(context)!.addWarehouse)
                : type == 'Shelf'
                    ? Text(S.of(context)!.addShelf)
                    : Text(S.of(context)!.addBriefcase),
            fromJsonT: Warehouse.fromJson,
            onSubmit: (context, label) => type == 'Warehouse'
                ? context.read<LabelCubit>().addWarehouse(label)
                : type == 'Shelf'
                    ? context.read<LabelCubit>().addShelf(label)
                    : context.read<LabelCubit>().addBoxcase(label),
            initialType: type,
            onChangedShelf: (s) {
              context.read<LabelCubit>().onChangeWarehouse(s!);
            },
            onChangedWarehouse: (w) {
              context.read<LabelCubit>().onChangeWarehouse(w!);
            },
            parentId: label?.id ?? -1,
          );
        },
      ),
    );
  }
}

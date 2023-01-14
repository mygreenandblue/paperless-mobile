import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/core/repository/state/repository_state.dart';
import 'package:paperless_mobile/features/labels/bloc/label_cubit.dart';
import 'package:paperless_mobile/features/labels/bloc/label_state.dart';
import 'package:paperless_mobile/features/labels/bloc/providers/document_type_bloc_provider.dart';

class LabelText<T extends Label, State extends RepositoryState>
    extends StatelessWidget {
  final int? id;
  final String placeholder;
  final TextStyle? style;

  const LabelText({
    super.key,
    this.style,
    this.id,
    this.placeholder = "",
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LabelCubit<T>(
        context.read<LabelRepository<T, State>>(),
      ),
      child: BlocBuilder<LabelCubit<T>, LabelState<T>>(
        builder: (context, state) {
          return Text(
            state.labels[id]?.toString() ?? placeholder,
            style: style,
          );
        },
      ),
    );
    ;
  }
}

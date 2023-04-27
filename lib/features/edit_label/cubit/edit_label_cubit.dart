import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit_mixin.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'edit_label_state.dart';
part 'edit_label_cubit.freezed.dart';

class EditLabelCubit extends Cubit<EditLabelState>
    with LabelCubitMixin<EditLabelState> {
  @override
  final LabelRepository labelRepository;

  EditLabelCubit(this.labelRepository) : super(const EditLabelState()) {
    labelRepository.addListener(
      this,
      onChanged: (labels) => state.copyWith(
        correspondents: labels.correspondents,
        documentTypes: labels.documentTypes,
        tags: labels.tags,
        storagePaths: labels.storagePaths,
      ),
    );
  }

  @override
  Future<void> close() {
    labelRepository.removeListener(this);
    return super.close();
  }
}

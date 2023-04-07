import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/label_repository.dart';
import 'package:paperless_mobile/features/labels/cubit/label_cubit_mixin.dart';

part 'label_state.dart';
part 'label_cubit.freezed.dart';

class LabelCubit extends Cubit<LabelState> with LabelCubitMixin<LabelState> {
  @override
  final LabelRepository labelRepository;

  LabelCubit(this.labelRepository) : super(const LabelState()) {
    labelRepository.addListener(
      this,
      onChanged: (labels) {
        emit(state.copyWith(
          correspondents: labels.correspondents,
          documentTypes: labels.documentTypes,
          storagePaths: labels.storagePaths,
          tags: labels.tags,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    labelRepository.removeListener(this);
    return super.close();
  }
}

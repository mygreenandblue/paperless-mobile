part of 'edit_label_cubit.dart';

class EditLabelState<T> extends Equatable {
  final Map<int, T> labels;

  const EditLabelState({this.labels = const {}});

  @override
  List<Object> get props => [labels];
}

import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';

abstract class PersistentRepository<T> extends HydratedCubit<T> {
  final Map<Object, StreamSubscription> _subscribers = {};

  PersistentRepository(T initialState) : super(initialState);

  void addListener(
    Object source, {
    required void Function(T) onChanged,
  }) {
    onChanged(state);
    _subscribers.putIfAbsent(source, () {
      return stream.listen((event) => onChanged(event));
    });
  }

  void removeListener(Object source) async {
    await _subscribers[source]?.cancel();
    _subscribers.remove(source);
  }

  @override
  Future<void> close() {
    _subscribers.forEach((key, subscription) {
      subscription.cancel();
    });
    return super.close();
  }
}

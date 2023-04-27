// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_view_repository_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SavedViewRepositoryState _$SavedViewRepositoryStateFromJson(
    Map<String, dynamic> json) {
  return _SavedViewRepositoryState.fromJson(json);
}

/// @nodoc
mixin _$SavedViewRepositoryState {
  Map<int, SavedView> get savedViews => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SavedViewRepositoryStateCopyWith<SavedViewRepositoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedViewRepositoryStateCopyWith<$Res> {
  factory $SavedViewRepositoryStateCopyWith(SavedViewRepositoryState value,
          $Res Function(SavedViewRepositoryState) then) =
      _$SavedViewRepositoryStateCopyWithImpl<$Res, SavedViewRepositoryState>;
  @useResult
  $Res call({Map<int, SavedView> savedViews});
}

/// @nodoc
class _$SavedViewRepositoryStateCopyWithImpl<$Res,
        $Val extends SavedViewRepositoryState>
    implements $SavedViewRepositoryStateCopyWith<$Res> {
  _$SavedViewRepositoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? savedViews = null,
  }) {
    return _then(_value.copyWith(
      savedViews: null == savedViews
          ? _value.savedViews
          : savedViews // ignore: cast_nullable_to_non_nullable
              as Map<int, SavedView>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SavedViewRepositoryStateCopyWith<$Res>
    implements $SavedViewRepositoryStateCopyWith<$Res> {
  factory _$$_SavedViewRepositoryStateCopyWith(
          _$_SavedViewRepositoryState value,
          $Res Function(_$_SavedViewRepositoryState) then) =
      __$$_SavedViewRepositoryStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<int, SavedView> savedViews});
}

/// @nodoc
class __$$_SavedViewRepositoryStateCopyWithImpl<$Res>
    extends _$SavedViewRepositoryStateCopyWithImpl<$Res,
        _$_SavedViewRepositoryState>
    implements _$$_SavedViewRepositoryStateCopyWith<$Res> {
  __$$_SavedViewRepositoryStateCopyWithImpl(_$_SavedViewRepositoryState _value,
      $Res Function(_$_SavedViewRepositoryState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? savedViews = null,
  }) {
    return _then(_$_SavedViewRepositoryState(
      savedViews: null == savedViews
          ? _value._savedViews
          : savedViews // ignore: cast_nullable_to_non_nullable
              as Map<int, SavedView>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SavedViewRepositoryState implements _SavedViewRepositoryState {
  const _$_SavedViewRepositoryState(
      {final Map<int, SavedView> savedViews = const {}})
      : _savedViews = savedViews;

  factory _$_SavedViewRepositoryState.fromJson(Map<String, dynamic> json) =>
      _$$_SavedViewRepositoryStateFromJson(json);

  final Map<int, SavedView> _savedViews;
  @override
  @JsonKey()
  Map<int, SavedView> get savedViews {
    if (_savedViews is EqualUnmodifiableMapView) return _savedViews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_savedViews);
  }

  @override
  String toString() {
    return 'SavedViewRepositoryState(savedViews: $savedViews)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SavedViewRepositoryState &&
            const DeepCollectionEquality()
                .equals(other._savedViews, _savedViews));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_savedViews));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SavedViewRepositoryStateCopyWith<_$_SavedViewRepositoryState>
      get copyWith => __$$_SavedViewRepositoryStateCopyWithImpl<
          _$_SavedViewRepositoryState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SavedViewRepositoryStateToJson(
      this,
    );
  }
}

abstract class _SavedViewRepositoryState implements SavedViewRepositoryState {
  const factory _SavedViewRepositoryState(
      {final Map<int, SavedView> savedViews}) = _$_SavedViewRepositoryState;

  factory _SavedViewRepositoryState.fromJson(Map<String, dynamic> json) =
      _$_SavedViewRepositoryState.fromJson;

  @override
  Map<int, SavedView> get savedViews;
  @override
  @JsonKey(ignore: true)
  _$$_SavedViewRepositoryStateCopyWith<_$_SavedViewRepositoryState>
      get copyWith => throw _privateConstructorUsedError;
}

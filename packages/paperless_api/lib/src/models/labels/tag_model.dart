import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_api/src/converters/hex_color_json_converter.dart';
import 'package:paperless_api/src/models/labels/label_model.dart';
import 'package:paperless_api/src/models/labels/matching_algorithm.dart';

part 'tag_model.g.dart';

@HexColorJsonConverter()
@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, constructor: "_")
class Tag extends Label {
  static const colorKey = 'color';
  static const isInboxTagKey = 'is_inbox_tag';
  static const textColorKey = 'text_color';
  static const legacyColourKey = 'colour';

  final Color? textColor;

  final bool isInboxTag;

  @protected
  @JsonKey(name: colorKey)
  Color? colorv2;

  @protected
  @Deprecated(
    "Alias for the field color. Deprecated since Paperless API v2. Please use the color getter to access the background color of this tag.",
  )
  @JsonKey(name: legacyColourKey)
  Color? colorv1;

  Color? get color => colorv2 ?? colorv1;

  /// Constructor to use for serialization.
  Tag._({
    super.id,
    required super.name,
    super.documentCount,
    super.isInsensitive = true,
    super.match,
    super.matchingAlgorithm,
    super.slug,
    this.colorv1,
    this.colorv2,
    this.textColor,
    this.isInboxTag = false,
  }) {
    colorv1 ??= colorv2;
    colorv2 ??= colorv1;
  }

  Tag({
    int? id,
    required String name,
    int? documentCount,
    bool? isInsensitive,
    String? match,
    MatchingAlgorithm matchingAlgorithm = MatchingAlgorithm.defaultValue,
    String? slug,
    Color? color,
    Color? textColor,
    bool? isInboxTag,
  }) : this._(
          id: id,
          name: name,
          documentCount: documentCount,
          isInsensitive: isInsensitive,
          match: match,
          matchingAlgorithm: matchingAlgorithm,
          slug: slug,
          textColor: textColor,
          colorv1: color,
          colorv2: color,
        );

  @override
  String toString() => name;

  @override
  Tag copyWith({
    int? id,
    String? name,
    String? match,
    MatchingAlgorithm? matchingAlgorithm,
    bool? isInsensitive,
    int? documentCount,
    String? slug,
    Color? color,
    Color? textColor,
    bool? isInboxTag,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      match: match ?? this.match,
      matchingAlgorithm: matchingAlgorithm ?? this.matchingAlgorithm,
      isInsensitive: isInsensitive ?? this.isInsensitive,
      documentCount: documentCount ?? this.documentCount,
      slug: slug ?? this.slug,
      color: color ?? this.color,
      textColor: textColor ?? this.textColor,
      isInboxTag: isInboxTag ?? this.isInboxTag,
    );
  }

  @override
  String get queryEndpoint => 'tags';

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        isInsensitive,
        documentCount,
        matchingAlgorithm,
        color,
        textColor,
        isInboxTag,
        match,
      ];

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TagToJson(this);
}

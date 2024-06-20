import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:edocs_api/src/converters/hex_color_json_converter.dart';
import 'package:edocs_api/src/converters/local_date_time_json_converter.dart';
import 'package:edocs_api/src/models/labels/matching_algorithm.dart';

part 'label_model.g.dart';

enum LabelType {
  correspondent,
  documentType,
  tag,
  storagePath,
  warehouse,
  folders,
}

sealed class Label extends Equatable implements Comparable {
  static const idKey = "id";
  static const nameKey = "name";
  static const slugKey = "slug";
  static const matchKey = "match";
  static const matchingAlgorithmKey = "matching_algorithm";
  static const isInsensitiveKey = "is_insensitive";
  static const documentCountKey = "document_count";
  static const parentWarehouseKey = "parent_warehouse";
  static const typeKey = "type";
  static const parentFolderKey = "parent_folder";

  String get queryEndpoint;

  final int? id;
  final String name;
  final String? slug;
  final String match;
  final MatchingAlgorithm matchingAlgorithm;
  final bool? isInsensitive;
  final int? documentCount;
  final int? owner;
  final bool? userCanChange;
  final int? parentWarehouse;
  final String? type;
  final int? parentFolder;

  const Label({
    this.id,
    required this.name,
    this.matchingAlgorithm = MatchingAlgorithm.defaultValue,
    this.match = "",
    this.isInsensitive = true,
    this.documentCount,
    this.slug,
    this.owner,
    this.userCanChange,
    this.type,
    this.parentWarehouse,
    this.parentFolder,
  });

  Label copyWith({
    int? id,
    String? name,
    String? match,
    MatchingAlgorithm? matchingAlgorithm,
    bool? isInsensitive,
    int? documentCount,
    String? slug,
  });

  @override
  String toString() {
    return name;
  }

  @override
  int compareTo(dynamic other) {
    return toString().toLowerCase().compareTo(other.toString().toLowerCase());
  }

  Map<String, dynamic> toJson();
}

@LocalDateTimeJsonConverter()
@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class Correspondent extends Label {
  final DateTime? lastCorrespondence;

  const Correspondent({
    this.lastCorrespondence,
    required super.name,
    super.id,
    super.slug,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.documentCount,
    super.owner,
    super.userCanChange,
  });

  factory Correspondent.fromJson(Map<String, dynamic> json) =>
      _$CorrespondentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CorrespondentToJson(this);

  @override
  String toString() {
    return name;
  }

  @override
  Correspondent copyWith({
    int? id,
    String? name,
    String? slug,
    String? match,
    MatchingAlgorithm? matchingAlgorithm,
    bool? isInsensitive,
    int? documentCount,
    DateTime? lastCorrespondence,
  }) {
    return Correspondent(
      id: id ?? this.id,
      name: name ?? this.name,
      documentCount: documentCount ?? documentCount,
      isInsensitive: isInsensitive ?? isInsensitive,
      match: match ?? this.match,
      matchingAlgorithm: matchingAlgorithm ?? this.matchingAlgorithm,
      slug: slug ?? this.slug,
      lastCorrespondence: lastCorrespondence ?? this.lastCorrespondence,
    );
  }

  @override
  String get queryEndpoint => 'correspondents';

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        isInsensitive,
        documentCount,
        lastCorrespondence,
        matchingAlgorithm,
        match,
      ];
}

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class DocumentType extends Label {
  const DocumentType({
    super.id,
    required super.name,
    super.slug,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.documentCount,
    super.owner,
    super.userCanChange,
  });

  factory DocumentType.fromJson(Map<String, dynamic> json) =>
      _$DocumentTypeFromJson(json);

  @override
  String get queryEndpoint => 'document_types';

  @override
  DocumentType copyWith({
    int? id,
    String? name,
    String? match,
    MatchingAlgorithm? matchingAlgorithm,
    bool? isInsensitive,
    int? documentCount,
    String? slug,
  }) {
    return DocumentType(
      id: id ?? this.id,
      name: name ?? this.name,
      match: match ?? this.match,
      matchingAlgorithm: matchingAlgorithm ?? this.matchingAlgorithm,
      isInsensitive: isInsensitive ?? this.isInsensitive,
      documentCount: documentCount ?? this.documentCount,
      slug: slug ?? this.slug,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$DocumentTypeToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        isInsensitive,
        documentCount,
        matchingAlgorithm,
        match,
      ];
}

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class StoragePath extends Label {
  static const pathKey = 'path';
  final String path;

  const StoragePath({
    super.id,
    required super.name,
    this.path = '',
    super.slug,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.documentCount,
    super.owner,
    super.userCanChange,
  });

  factory StoragePath.fromJson(Map<String, dynamic> json) =>
      _$StoragePathFromJson(json);

  @override
  String toString() {
    return name;
  }

  @override
  StoragePath copyWith({
    int? id,
    String? name,
    String? slug,
    String? match,
    MatchingAlgorithm? matchingAlgorithm,
    bool? isInsensitive,
    int? documentCount,
    String? path,
  }) {
    return StoragePath(
      id: id ?? this.id,
      name: name ?? this.name,
      documentCount: documentCount ?? documentCount,
      isInsensitive: isInsensitive ?? isInsensitive,
      path: path ?? this.path,
      match: match ?? this.match,
      matchingAlgorithm: matchingAlgorithm ?? this.matchingAlgorithm,
      slug: slug ?? this.slug,
    );
  }

  @override
  String get queryEndpoint => 'storage_paths';

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        isInsensitive,
        documentCount,
        path,
        matchingAlgorithm,
        match,
      ];

  @override
  Map<String, dynamic> toJson() => _$StoragePathToJson(this);
}

@HexColorJsonConverter()
@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
class Tag extends Label {
  static const colorKey = 'color';
  static const isInboxTagKey = 'is_inbox_tag';
  static const textColorKey = 'text_color';
  static const legacyColourKey = 'colour';
  final Color? textColor;
  final Color? color;

  final bool isInboxTag;

  const Tag({
    super.id,
    required super.name,
    super.documentCount,
    super.isInsensitive,
    super.match,
    super.matchingAlgorithm = MatchingAlgorithm.defaultValue,
    super.slug,
    this.color,
    this.textColor,
    this.isInboxTag = false,
    super.owner,
    super.userCanChange,
  });

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

@LocalDateTimeJsonConverter()
@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class Warehouse extends Label {
  const Warehouse({
    required super.name,
    super.parentWarehouse,
    super.id,
    super.slug,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.documentCount,
    super.owner,
    super.userCanChange,
    required super.type,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) =>
      _$WarehouseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WarehouseToJson(this);

  @override
  String toString() {
    return name;
  }

  @override
  Warehouse copyWith({
    int? id,
    String? name,
    String? slug,
    String? match,
    MatchingAlgorithm? matchingAlgorithm,
    bool? isInsensitive,
    int? documentCount,
    int? parenWarehouse,
    String? type,
  }) {
    return Warehouse(
        id: id ?? this.id,
        name: name ?? this.name,
        documentCount: documentCount ?? documentCount,
        isInsensitive: isInsensitive ?? isInsensitive,
        match: match ?? this.match,
        matchingAlgorithm: matchingAlgorithm ?? this.matchingAlgorithm,
        slug: slug ?? this.slug,
        parentWarehouse: parentWarehouse ?? parentWarehouse,
        type: type ?? this.type);
  }

  @override
  String get queryEndpoint => 'warehouses';

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        isInsensitive,
        documentCount,
        parentWarehouse,
        matchingAlgorithm,
        match,
        type
      ];
}

@LocalDateTimeJsonConverter()
@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class Folder extends Label {
  static const pathFolderKey = 'path';
  final String? path;
  final String? checksum;
  final int? childFolderCount;

  const Folder({
    required super.name,
    super.id,
    super.slug,
    super.match,
    super.matchingAlgorithm,
    super.isInsensitive,
    super.documentCount,
    super.owner,
    super.userCanChange,
    super.parentFolder,
    this.path,
    this.checksum,
    this.childFolderCount,
  });

  factory Folder.fromJson(Map<String, dynamic> json) => _$FolderFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FolderToJson(this);

  @override
  String toString() {
    return 'Folder(name: $name, id: $id, path: $path, parent_folder: $parentFolder, document_count: $documentCount)';
  }

  @override
  String get queryEndpoint => 'folders';

  @override
  Folder copyWith({
    String? name,
    int? id,
    String? slug,
    String? match,
    MatchingAlgorithm? matchingAlgorithm,
    bool? isInsensitive,
    int? documentCount,
    int? owner,
    bool? userCanChange,
    int? parentFolder,
    String? path,
    String? checksum,
    int? childFolderCount,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      documentCount: documentCount ?? documentCount,
      isInsensitive: isInsensitive ?? isInsensitive,
      match: match ?? this.match,
      matchingAlgorithm: matchingAlgorithm ?? this.matchingAlgorithm,
      slug: slug ?? this.slug,
      parentFolder: parentFolder ?? parentFolder,
      path: type ?? this.path,
      checksum: checksum ?? checksum,
      childFolderCount: childFolderCount ?? childFolderCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        isInsensitive,
        documentCount,
        parentFolder,
        matchingAlgorithm,
        match,
      ];

  dynamic getValue(String key) {
    switch (key) {
      case 'id':
        return id;
      case 'document_count':
        return documentCount;
      case 'slug':
        return slug;
      case 'user_can_change':
        return userCanChange;
      case 'checksum':
        return checksum;
      case 'name':
        return name;
      case 'match':
        return match;
      case 'matching_algorithm':
        return matchingAlgorithm;
      case 'is_insensitive':
        return isInsensitive;
      case 'path':
        return path;
      case 'owner':
        return owner;
      case 'parent_folder':
        return parentFolder;
      case 'child_folder_count':
        return childFolderCount;
      default:
        return null;
    }
  }

  bool hasField(Map<String, dynamic> json, String fieldName) {
    return json.containsKey(fieldName);
  }
}

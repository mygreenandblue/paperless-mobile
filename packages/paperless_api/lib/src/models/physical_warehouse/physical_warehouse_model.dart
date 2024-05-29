// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'physical_warehouse_model.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class WarehouseModel extends Equatable implements Comparable {
  static const idKey = 'id';
  static const slugKey = 'slug';
  static const nameKey = 'name';
  static const typeKey = 'type';
  static const documentCountKey = 'document_count';
  static const isSharedByRequesterKey = 'is_shared_by_requester';
  static const parentWarehouseKey = 'parent_warehouse';

  final int? id;
  final int? documentCount;
  final String? slug;
  final bool? userCanChange;
  final bool? isSharedByRequester;
  final String? name;
  final String? type;
  final int? owner;
  final WarehouseModel? parentWarehouse;

  const WarehouseModel({
    required this.id,
    this.documentCount,
    this.slug,
    this.userCanChange,
    this.isSharedByRequester,
    this.name,
    this.type,
    this.owner,
    this.parentWarehouse,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) =>
      _$WarehouseModelFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseModelToJson(this);

  WarehouseModel copyWith({
    int? id,
    int? documentCount,
    String? slug,
    bool? userCanChange,
    bool? isSharedByRequester,
    String? name,
    String? type,
    int? owner,
    WarehouseModel? parentWarehouse,
  }) {
    return WarehouseModel(
      id: id ?? this.id,
      documentCount: documentCount ?? this.documentCount,
      slug: slug ?? this.slug,
      userCanChange: userCanChange ?? this.userCanChange,
      isSharedByRequester: isSharedByRequester ?? this.isSharedByRequester,
      name: name ?? this.name,
      type: type ?? this.type,
      owner: owner ?? this.owner,
      parentWarehouse: parentWarehouse ?? this.parentWarehouse,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      documentCount,
      slug,
      userCanChange,
      isSharedByRequester,
      name,
      type,
      owner,
      parentWarehouse,
    ];
  }

  @override
  String toString() {
    return name ?? '';
  }

  @override
  int compareTo(dynamic other) {
    return toString().toLowerCase().compareTo(other.toString().toLowerCase());
  }
}

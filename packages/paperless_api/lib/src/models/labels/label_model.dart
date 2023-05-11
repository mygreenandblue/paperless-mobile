import 'package:equatable/equatable.dart';
import 'package:paperless_api/src/models/labels/matching_algorithm.dart';

abstract class Label extends Equatable implements Comparable {
  static const idKey = "id";
  static const nameKey = "name";
  static const slugKey = "slug";
  static const matchKey = "match";
  static const matchingAlgorithmKey = "matching_algorithm";
  static const isInsensitiveKey = "is_insensitive";
  static const documentCountKey = "document_count";

  String get queryEndpoint;

  final int? id;
  final String name;
  final String? slug;
  final String? match;
  final MatchingAlgorithm matchingAlgorithm;
  final bool? isInsensitive;
  final int? documentCount;
  final int? owner;
  final bool? userCanChange;

  const Label({
    this.id,
    required this.name,
    this.matchingAlgorithm = MatchingAlgorithm.defaultValue,
    this.match,
    this.isInsensitive = true,
    this.documentCount,
    this.slug,
    this.owner,
    this.userCanChange,
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

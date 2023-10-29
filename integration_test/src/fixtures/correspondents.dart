import 'package:paperless_api/paperless_api.dart';

final ikeaCorrespondent = Correspondent.fromJson(const {
  "id": 1,
  "slug": "ikea",
  "name": "IKEA",
  "match": "ikea",
  "matching_algorithm": 1,
  "is_insensitive": true,
  "document_count": 3,
  "owner": 1,
  "user_can_change": true
});
final mediaMarktCorrespondent = Correspondent.fromJson(const {
  "id": 2,
  "slug": "mediamarkt",
  "name": "Media Markt",
  "match": "media markt",
  "matching_algorithm": 1,
  "is_insensitive": true,
  "document_count": 3,
  "owner": 1,
  "user_can_change": true
});
final appleCorrespondent = Correspondent.fromJson(const {
  "id": 3,
  "slug": "apple",
  "name": "Apple",
  "match": "apple",
  "matching_algorithm": 1,
  "is_insensitive": true,
  "document_count": 3,
  "owner": 1,
  "user_can_change": true
});

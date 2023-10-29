import 'package:paperless_api/paperless_api.dart';

final inboxTag = Tag.fromJson(const {
  "id": 1,
  "slug": "inbox",
  "name": "Inbox",
  "colour": 1,
  "match": "",
  "matching_algorithm": 6,
  "is_insensitive": true,
  "is_inbox_tag": true,
  "document_count": 2,
  "owner": 1,
  "user_can_change": true
});
final urgentTag = Tag.fromJson(const {
  "id": 2,
  "slug": "urgent",
  "name": "Urgent",
  "colour": 1,
  "match": "",
  "matching_algorithm": 6,
  "is_insensitive": true,
  "is_inbox_tag": false,
  "document_count": 4,
  "owner": 1,
  "user_can_change": true
});

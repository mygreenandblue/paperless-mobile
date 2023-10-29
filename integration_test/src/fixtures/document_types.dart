import 'package:paperless_api/paperless_api.dart';

final invoiceDocumentType = DocumentType.fromJson(const {
  "id": 1,
  "slug": "invoice",
  "name": "Invoice",
  "match": "invoice",
  "matching_algorithm": 1,
  "is_insensitive": true,
  "document_count": 5,
  "owner": 1,
  "user_can_change": true
});
final contractDocumentType = DocumentType.fromJson(const {
  "id": 2,
  "slug": "contract",
  "name": "Contract",
  "match": "contract",
  "matching_algorithm": 1,
  "is_insensitive": true,
  "document_count": 4,
  "owner": 1,
  "user_can_change": true
});

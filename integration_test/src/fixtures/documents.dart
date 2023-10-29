import 'package:paperless_api/paperless_api.dart';

final document1 = DocumentModel.fromJson(const {
  "id": 1,
  "correspondent": 1,
  "document_type": 1,
  "storage_path": null,
  "title": "Rechnung 1 title",
  "content":
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
  "tags": [1, 2],
  "created": "2020-01-15T00:00:00Z",
  "created_date": "2020-01-15",
  "modified": "2020-01-17T00:00:00Z",
  "added": "2020-01-16T17:25:00Z",
  "archive_serial_number": null,
  "original_file_name": "document_1.pdf",
  "archived_file_name": "document_1.pdf",
  "owner": 1,
  "user_can_change": true,
  "notes": []
});
final document2 = DocumentModel.fromJson(const {
  "id": 2,
  "correspondent": 1,
  "document_type": null,
  "storage_path": null,
  "title": "Rechnung 1 title",
  "content":
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
  "tags": [2],
  "created": "2021-01-15T00:00:00Z",
  "created_date": "2021-01-15",
  "modified": "2021-01-15T00:00:00Z",
  "added": "2022-12-06T17:25:00Z",
  "archive_serial_number": null,
  "original_file_name": "document_1.pdf",
  "archived_file_name": "document_1.pdf",
  "owner": 1,
  "user_can_change": true,
  "notes": []
});
final document3 = DocumentModel.fromJson(const {
  "id": 3,
  "correspondent": 2,
  "document_type": 1,
  "storage_path": null,
  "title": "Rechnung 1 title",
  "content":
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
  "tags": [2],
  "created": "2020-01-15T00:00:00Z",
  "created_date": "2020-01-15",
  "modified": "2020-01-17T00:00:00Z",
  "added": "2020-01-16T17:25:00Z",
  "archive_serial_number": null,
  "original_file_name": "document_1.pdf",
  "archived_file_name": "document_1.pdf",
  "owner": 1,
  "user_can_change": true,
  "notes": [1]
});
final document4 = DocumentModel.fromJson(const {
  "id": 4,
  "correspondent": 2,
  "document_type": 2,
  "storage_path": null,
  "title": "Rechnung 1 title",
  "content":
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
  "tags": [],
  "created": "2020-01-15T00:00:00Z",
  "created_date": "2020-01-15",
  "modified": "2020-01-17T00:00:00Z",
  "added": "2020-01-16T17:25:00Z",
  "archive_serial_number": null,
  "original_file_name": "document_1.pdf",
  "archived_file_name": "document_1.pdf",
  "owner": 1,
  "user_can_change": true,
  "notes": []
});
final document5 = DocumentModel.fromJson(const {
  "id": 5,
  "correspondent": 3,
  "document_type": 1,
  "storage_path": null,
  "title": "Rechnung 1 title",
  "content":
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
  "tags": [2],
  "created": "2020-01-15T00:00:00Z",
  "created_date": "2020-01-15",
  "modified": "2020-01-17T00:00:00Z",
  "added": "2020-01-16T17:25:00Z",
  "archive_serial_number": null,
  "original_file_name": "document_1.pdf",
  "archived_file_name": "document_1.pdf",
  "owner": 1,
  "user_can_change": true,
  "notes": []
});
final document6 = DocumentModel.fromJson(const {
  "id": 6,
  "correspondent": 3,
  "document_type": 2,
  "storage_path": null,
  "title": "Rechnung 1 title",
  "content":
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
  "tags": [],
  "created": "2020-01-15T00:00:00Z",
  "created_date": "2020-01-15",
  "modified": "2020-01-17T00:00:00Z",
  "added": "2020-01-16T17:25:00Z",
  "archive_serial_number": null,
  "original_file_name": "document_1.pdf",
  "archived_file_name": "document_1.pdf",
  "owner": 1,
  "user_can_change": true,
  "notes": []
});
final document7 = DocumentModel.fromJson(const {
  "id": 7,
  "correspondent": 3,
  "document_type": 1,
  "storage_path": null,
  "title": "Rechnung 1 title",
  "content":
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
  "tags": [],
  "created": "2020-01-15T00:00:00Z",
  "created_date": "2020-01-15",
  "modified": "2020-01-17T00:00:00Z",
  "added": "2020-01-16T17:25:00Z",
  "archive_serial_number": null,
  "original_file_name": "document_1.pdf",
  "archived_file_name": "document_1.pdf",
  "owner": 1,
  "user_can_change": true,
  "notes": []
});
final document8 = DocumentModel.fromJson(const {
  "id": 8,
  "correspondent": null,
  "document_type": 1,
  "storage_path": null,
  "title": "Rechnung 1 title",
  "content":
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
  "tags": [],
  "created": "2020-01-15T00:00:00Z",
  "created_date": "2020-01-15",
  "modified": "2020-01-17T00:00:00Z",
  "added": "2020-01-16T17:25:00Z",
  "archive_serial_number": null,
  "original_file_name": "document_1.pdf",
  "archived_file_name": "document_1.pdf",
  "owner": 1,
  "user_can_change": true,
  "notes": []
});
final document9 = DocumentModel.fromJson(const {
  "id": 9,
  "correspondent": 2,
  "document_type": 2,
  "storage_path": null,
  "title": "Rechnung 1 title",
  "content":
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
  "tags": [],
  "created": "2020-01-15T00:00:00Z",
  "created_date": "2020-01-15",
  "modified": "2020-01-17T00:00:00Z",
  "added": "2020-01-16T17:25:00Z",
  "archive_serial_number": null,
  "original_file_name": "document_1.pdf",
  "archived_file_name": "document_1.pdf",
  "owner": 1,
  "user_can_change": true,
  "notes": []
});
final document10 = DocumentModel.fromJson(const {
  "id": 10,
  "correspondent": 1,
  "document_type": 2,
  "storage_path": null,
  "title": "Rechnung 1 title",
  "content":
      "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.",
  "tags": [],
  "created": "2020-01-15T00:00:00Z",
  "created_date": "2020-01-15",
  "modified": "2020-01-17T00:00:00Z",
  "added": "2020-01-16T17:25:00Z",
  "archive_serial_number": null,
  "original_file_name": "document_1.pdf",
  "archived_file_name": "document_1.pdf",
  "owner": 1,
  "user_can_change": true,
  "notes": []
});

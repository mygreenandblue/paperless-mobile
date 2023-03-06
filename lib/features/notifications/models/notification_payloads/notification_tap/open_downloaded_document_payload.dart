import 'package:json_annotation/json_annotation.dart';
import 'package:paperless_mobile/features/notifications/models/notification_actions.dart';
import 'package:paperless_mobile/features/notifications/models/notification_payloads/notification_tap/notification_tap_response_payload.dart';

part 'open_downloaded_document_payload.g.dart';

@JsonSerializable()
class OpenDownloadedDocumentPayload extends NotificationTapResponsePayload {
  final String filePath;
  OpenDownloadedDocumentPayload({
    required this.filePath,
    super.type = NotificationResponseOpenAction.openDownloadedDocumentPath,
  });

  factory OpenDownloadedDocumentPayload.fromJson(Map<String, dynamic> json) =>
      _$OpenDownloadedDocumentPayloadFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$OpenDownloadedDocumentPayloadToJson(this);
}

import 'package:paperless_mobile/features/notifications/models/notification_actions.dart';

abstract class NotificationTapResponsePayload {
  final NotificationResponseOpenAction type;

  Map<String, dynamic> toJson();
  NotificationTapResponsePayload({required this.type});
}

enum NotificationChannel {
  task("task_channel", "Paperless tasks"),
  documentDownload("document_download_channel", "Document downloads");

  final String id;
  final String name;

  const NotificationChannel(this.id, this.name);
}

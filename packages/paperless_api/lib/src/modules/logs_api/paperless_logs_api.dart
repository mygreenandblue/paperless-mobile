abstract class PaperlessLogsApi {
  Future<List<String>> findLogTypes();
  Future<List<String>> fetchLog(String logType);
}

import 'package:dio/dio.dart';
import 'package:edocs_api/edocs_api.dart';

abstract class EdocsApiFactory {
  EdocsDocumentsApi createDocumentsApi(
    Dio dio, {
    required int apiVersion,
  });
  EdocsSavedViewsApi createSavedViewsApi(
    Dio dio, {
    required int apiVersion,
  });
  EdocsLabelsApi createLabelsApi(
    Dio dio, {
    required int apiVersion,
  });
  EdocsServerStatsApi createServerStatsApi(
    Dio dio, {
    required int apiVersion,
  });
  EdocsTasksApi createTasksApi(
    Dio dio, {
    required int apiVersion,
  });
  EdocsAuthenticationApi createAuthenticationApi(Dio dio);
  EdocsUserApi createUserApi(
    Dio dio, {
    required int apiVersion,
  });
}

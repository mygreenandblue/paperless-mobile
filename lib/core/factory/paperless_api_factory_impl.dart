import 'package:dio/dio.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/factory/paperless_api_factory.dart';
import 'package:paperless_mobile/core/security/session_manager.dart';

class PaperlessApiFactoryImpl implements PaperlessApiFactory {
  final SessionManager sessionManager;

  PaperlessApiFactoryImpl(this.sessionManager);

  @override
  PaperlessDocumentsApi createDocumentsApi(Dio dio, {required int apiVersion}) {
    return PaperlessDocumentsApiImpl(dio);
  }

  @override
  PaperlessLabelsApi createLabelsApi(Dio dio, {required int apiVersion}) {
    return PaperlessLabelApiImpl(dio);
  }

  @override
  PaperlessSavedViewsApi createSavedViewsApi(Dio dio, {required int apiVersion}) {
    return PaperlessSavedViewsApiImpl(dio);
  }

  @override
  PaperlessServerStatsApi createServerStatsApi(Dio dio, {required int apiVersion}) {
    return PaperlessServerStatsApiImpl(dio);
  }

  @override
  PaperlessTasksApi createTasksApi(Dio dio, {required int apiVersion}) {
    return PaperlessTasksApiImpl(dio);
  }
}

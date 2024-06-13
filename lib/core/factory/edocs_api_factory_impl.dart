import 'package:dio/dio.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/factory/edocs_api_factory.dart';
import 'package:edocs_mobile/core/security/session_manager.dart';

class EdocsApiFactoryImpl implements EdocsApiFactory {
  final SessionManager sessionManager;

  EdocsApiFactoryImpl(this.sessionManager);

  @override
  EdocsDocumentsApi createDocumentsApi(Dio dio, {required int apiVersion}) {
    return EdocsDocumentsApiImpl(dio);
  }

  @override
  EdocsLabelsApi createLabelsApi(Dio dio, {required int apiVersion}) {
    return EdocsLabelApiImpl(dio);
  }

  @override
  EdocsSavedViewsApi createSavedViewsApi(Dio dio, {required int apiVersion}) {
    return EdocsSavedViewsApiImpl(dio);
  }

  @override
  EdocsServerStatsApi createServerStatsApi(Dio dio, {required int apiVersion}) {
    return EdocsServerStatsApiImpl(dio);
  }

  @override
  EdocsTasksApi createTasksApi(Dio dio, {required int apiVersion}) {
    return EdocsTasksApiImpl(dio);
  }

  @override
  EdocsAuthenticationApi createAuthenticationApi(Dio dio) {
    return EdocsAuthenticationApiImpl(dio);
  }

  @override
  EdocsUserApi createUserApi(Dio dio, {required int apiVersion}) {
    if (apiVersion == 3) {
      return EdocsUserApiV3Impl(dio);
    } else if (apiVersion < 3) {
      return EdocsUserApiV2Impl(dio);
    }
    throw Exception("API $apiVersion not supported.");
  }
}

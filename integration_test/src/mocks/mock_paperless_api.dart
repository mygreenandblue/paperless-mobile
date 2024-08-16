import 'package:dio/src/dio.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/factory/edocs_api_factory.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<EdocsAuthenticationApi>(),
  MockSpec<EdocsDocumentsApi>(),
  MockSpec<EdocsLabelsApi>(),
  MockSpec<EdocsUserApi>(),
  MockSpec<EdocsServerStatsApi>(),
  MockSpec<EdocsSavedViewsApi>(),
  MockSpec<EdocsTasksApi>(),
])
class MockEdocsApiFactory implements EdocsApiFactory {
  final EdocsAuthenticationApi authenticationApi = EdocsAuthenticationApi();
  final EdocsDocumentsApi documentApi = MockEdocsDocumentsApi();
  final EdocsLabelsApi labelsApi = MockEdocsLabelsApi();
  final EdocsUserApi userApi = MockEdocsUserApi();
  final EdocsSavedViewsApi savedViewsApi = MockEdocsSavedViewsApi();
  final EdocsServerStatsApi serverStatsApi = MockEdocsServerStatsApi();
  final EdocsTasksApi tasksApi = MockEdocsTasksApi();

  @override
  EdocsAuthenticationApi createAuthenticationApi(Dio dio) {
    return authenticationApi;
  }

  @override
  EdocsDocumentsApi createDocumentsApi(Dio dio, {required int apiVersion}) {
    return documentApi;
  }

  @override
  EdocsLabelsApi createLabelsApi(Dio dio, {required int apiVersion}) {
    return labelsApi;
  }

  @override
  EdocsSavedViewsApi createSavedViewsApi(
    Dio dio, {
    required int apiVersion,
  }) {
    return savedViewsApi;
  }

  @override
  EdocsServerStatsApi createServerStatsApi(Dio dio, {required int apiVersion}) {
    return serverStatsApi;
  }

  @override
  EdocsTasksApi createTasksApi(Dio dio, {required int apiVersion}) {
    return tasksApi;
  }

  @override
  EdocsUserApi createUserApi(Dio dio, {required int apiVersion}) {
    return userApi;
  }
}

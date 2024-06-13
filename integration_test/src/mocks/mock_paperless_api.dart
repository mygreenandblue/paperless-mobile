import 'package:dio/src/dio.dart';
import 'package:edocs_api/edocs_api.dart';
import 'package:edocs_mobile/core/factory/edocs_api_factory.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<edocsAuthenticationApi>(),
  MockSpec<EdocsDocumentsApi>(),
  MockSpec<edocsLabelsApi>(),
  MockSpec<edocsUserApi>(),
  MockSpec<edocsServerStatsApi>(),
  MockSpec<edocsSavedViewsApi>(),
  MockSpec<EdocsTasksApi>(),
])
import 'mock_edocs_api.mocks.dart';

class MockEdocsApiFactory implements EdocsApiFactory {
  final edocsAuthenticationApi authenticationApi = MockedocsAuthenticationApi();
  final EdocsDocumentsApi documentApi = MockEdocsDocumentsApi();
  final edocsLabelsApi labelsApi = MockedocsLabelsApi();
  final edocsUserApi userApi = MockedocsUserApi();
  final edocsSavedViewsApi savedViewsApi = MockedocsSavedViewsApi();
  final edocsServerStatsApi serverStatsApi = MockedocsServerStatsApi();
  final EdocsTasksApi tasksApi = MockEdocsTasksApi();

  @override
  edocsAuthenticationApi createAuthenticationApi(Dio dio) {
    return authenticationApi;
  }

  @override
  EdocsDocumentsApi createDocumentsApi(Dio dio, {required int apiVersion}) {
    return documentApi;
  }

  @override
  edocsLabelsApi createLabelsApi(Dio dio, {required int apiVersion}) {
    return labelsApi;
  }

  @override
  edocsSavedViewsApi createSavedViewsApi(
    Dio dio, {
    required int apiVersion,
  }) {
    return savedViewsApi;
  }

  @override
  edocsServerStatsApi createServerStatsApi(Dio dio, {required int apiVersion}) {
    return serverStatsApi;
  }

  @override
  EdocsTasksApi createTasksApi(Dio dio, {required int apiVersion}) {
    return tasksApi;
  }

  @override
  edocsUserApi createUserApi(Dio dio, {required int apiVersion}) {
    return userApi;
  }
}

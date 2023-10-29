import 'package:dio/dio.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/factory/paperless_api_factory.dart';
import 'package:mocktail/mocktail.dart';

class MockPaperlessApiFactory implements PaperlessApiFactory {
  static final authApi = MockPaperlessAuthenticationApi();
  static final documentsApi = MockPaperlessDocumentsApi();
  static final labelsApi = MockPaperlessLabelsApi();
  static final savedViewsApi = MockPaperlessSavedViewsApi();
  static final serverStatsApi = MockPaperlessServerStatsApi();
  static final tasksApi = MockPaperlessTasksApi();
  static final userApi = MockPaperlessUserApi();

  @override
  PaperlessAuthenticationApi createAuthenticationApi(Dio dio) {
    return authApi;
  }

  @override
  PaperlessDocumentsApi createDocumentsApi(Dio dio, {required int apiVersion}) {
    return documentsApi;
  }

  @override
  PaperlessLabelsApi createLabelsApi(Dio dio, {required int apiVersion}) {
    return labelsApi;
  }

  @override
  PaperlessSavedViewsApi createSavedViewsApi(Dio dio,
      {required int apiVersion}) {
    return savedViewsApi;
  }

  @override
  PaperlessServerStatsApi createServerStatsApi(Dio dio,
      {required int apiVersion}) {
    return serverStatsApi;
  }

  @override
  PaperlessTasksApi createTasksApi(Dio dio, {required int apiVersion}) {
    return tasksApi;
  }

  @override
  PaperlessUserApi createUserApi(Dio dio, {required int apiVersion}) {
    return userApi;
  }
}

class MockPaperlessAuthenticationApi extends Mock
    implements PaperlessAuthenticationApi {}

class MockPaperlessDocumentsApi extends Mock implements PaperlessDocumentsApi {}

class MockPaperlessLabelsApi extends Mock implements PaperlessLabelsApi {}

class MockPaperlessSavedViewsApi extends Mock
    implements PaperlessSavedViewsApi {}

class MockPaperlessServerStatsApi extends Mock
    implements PaperlessServerStatsApi {}

class MockPaperlessUserApi extends Mock implements PaperlessUserApi {}

class MockPaperlessTasksApi extends Mock implements PaperlessTasksApi {}

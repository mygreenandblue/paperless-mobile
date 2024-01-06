import 'package:dio/dio.dart';

class LanguageHeaderInterceptor extends Interceptor {
  final String Function() preferredLocaleSubtagBuilder;
  LanguageHeaderInterceptor(this.preferredLocaleSubtagBuilder);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    late String languages;
    if (preferredLocaleSubtagBuilder() == "en") {
      languages = "en";
    } else {
      languages = "${preferredLocaleSubtagBuilder()},en;q=0.7,en-US;q=0.6";
    }
    options.headers.addAll({"Accept-Language": languages});
    handler.next(options);
  }
}

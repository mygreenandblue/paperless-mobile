import 'package:equatable/equatable.dart';

class PaperlessLog with EquatableMixin {
  final List<String> log;
  final bool notFound;
  final bool hasLoaded;
  final bool isLoading;

  PaperlessLog({
    this.log = const [],
    this.hasLoaded = false,
    this.isLoading = false,
    this.notFound = false,
  });

  @override
  List<Object?> get props => [log, hasLoaded, isLoading];

  PaperlessLog copyWith({
    List<String>? log,
    bool? hasLoaded,
    bool? isLoading,
    bool? notFound,
  }) {
    return PaperlessLog(
      log: log ?? this.log,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      notFound: notFound ?? this.notFound,
    );
  }
}

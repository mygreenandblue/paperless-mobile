part of 'logs_cubit.dart';

class LogsState extends Equatable {
  final bool isLoading;
  final bool hasLoaded;
  final List<String> types;
  final Map<String, PaperlessLog> logs;

  const LogsState({
    this.isLoading = false,
    this.hasLoaded = false,
    this.types = const [],
    this.logs = const {},
  });

  @override
  List<Object> get props => [
        types,
        logs,
        isLoading,
        hasLoaded,
      ];

  LogsState copyWith({
    bool? isLoading,
    bool? hasLoaded,
    List<String>? types,
    Map<String, PaperlessLog>? logs,
  }) {
    return LogsState(
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      types: types ?? this.types,
      logs: logs ?? this.logs,
    );
  }
}

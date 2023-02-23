import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/features/logs/model/paperless_log.dart';

part 'logs_state.dart';

class LogsCubit extends Cubit<LogsState> {
  final PaperlessLogsApi _api;
  LogsCubit(this._api) : super(const LogsState());

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true));
    try {
      final availableTypes = await _api.findLogTypes();
      emit(
        state.copyWith(
          types: availableTypes,
          logs: {for (var key in availableTypes) key: PaperlessLog()},
          hasLoaded: true,
        ),
      );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> updateLogs(String type) async {
    emit(
      state.copyWith(
        logs: {
          ...state.logs,
          type: (state.logs[type] ?? PaperlessLog()).copyWith(
            isLoading: true,
          )
        },
      ),
    );
    try {
      final logs = await _api.fetchLog(type);
      emit(
        state.copyWith(
          logs: {
            ...state.logs,
            type: PaperlessLog(
              hasLoaded: true,
              isLoading: true,
              log: logs,
            ),
          },
        ),
      );
    } on PaperlessServerException catch (error) {
      if (error.code == ErrorCode.logNotFound) {
        emit(
          state.copyWith(
            logs: {
              ...state.logs,
              type: PaperlessLog(
                notFound: true,
                hasLoaded: true,
              ),
            },
          ),
        );
      }
    }
  }
}

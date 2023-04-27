import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/bloc/server_information_state.dart';

class ServerInformationCubit extends Cubit<ServerInformationState> {
  final PaperlessServerStatsApi _api;

  ServerInformationCubit(this._api) : super(ServerInformationState());

  Future<void> updateInformation() async {
    final information = await _api.getServerInformation();
    emit(ServerInformationState(
      isLoaded: true,
      information: information,
    ));
  }
}

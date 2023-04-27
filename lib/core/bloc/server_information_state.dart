import 'package:paperless_api/paperless_api.dart';

class ServerInformationState {
  final bool isLoaded;
  final PaperlessServerInformationModel? information;

  ServerInformationState({
    this.isLoaded = false,
    this.information,
  });
}

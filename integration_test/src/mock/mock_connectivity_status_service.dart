import 'package:mocktail/mocktail.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/features/login/model/client_certificate.dart';
import 'package:paperless_mobile/features/login/model/reachability_status.dart';

class MockConnectivityStatusService implements ConnectivityStatusService {
  @override
  Stream<bool> connectivityChanges() {
    return Stream.value(true);
  }

  @override
  Future<bool> isConnectedToInternet() async {
    return true;
  }

  @override
  Future<ReachabilityStatus> isPaperlessServerReachable(String serverAddress,
      [ClientCertificate? clientCertificate]) async {
    return ReachabilityStatus.reachable;
  }

  @override
  Future<bool> isServerReachable(String serverAddress) async {
    return true;
  }
}

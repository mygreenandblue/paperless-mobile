

import 'package:mock_server/mock_server.dart';
import 'package:paperless_mobile/main.dart' as ParentMain;

void main() async {
  await LocalMockApiServer().start();
  ParentMain.main();
}


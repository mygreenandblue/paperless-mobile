library mock_server;

import 'dart:convert';


import 'package:logging/logging.dart';

import 'package:shelf/shelf.dart';

import 'package:shelf/shelf_io.dart' as shelf_io;

import 'package:shelf_router/shelf_router.dart' as shelf_router;


Logger log = Logger('LocalMockApiServer');


class LocalMockApiServer {

  static final host = 'localhost';

  static final port = 3131;

  static get baseUrl => 'http://$host:$port/';


  late shelf_router.Router app;


  LocalMockApiServer() {

    app = shelf_router.Router();


    app.get('/api/', (Request req) async {
      log.info('Responding to /api');
      return JsonMockResponse.ok({
      });
    });

    app.post('/api/token/', (Request req) async {
      log.info('Responding to /api/token/');
      var body = await req.bodyJsonMap();
      if (body?['username'] == 'test' && body?['password'] == 'test') {
        return JsonMockResponse.ok({
          'token': 'testToken'
        });
      } else {
        return Response.unauthorized(
          'Unauthorized'
        );
      }

    });

    app.get('/api/ui_settings/', (Request req) async {
      log.info('Responding to /api/ui_settings/');
      return JsonMockResponse.ok({
        'user': {
          'id': 1,
          'username': 'test',
          'displayName': 'Test User'
        }
      });
    });

    app.get('/api/users/<userId>/', (Request req, String userId) async {
      log.info('Responding to /api/users/<userId>/');
      return JsonMockResponse.ok({
        'id': 1,
        'username': 'test',
        'displayName': 'Test User',
        'email': 'test@test.pl',
        'firstName': 'Test',
        'lastName': 'User',
        'dateJoined': '2000-01-23T01:23:45',
        'isStaff': false,
        'isActive': true,
        'isSuperuser': true,
        'groups': [],
        'userPermissions': [],
        'inheritedPermissions': []
      });
    });

  }


  Future<void> start() async {

    log.info('starting...');


    var handler = const Pipeline().addMiddleware(

      logRequests(logger: (message, isError) {

        if (isError)

          log.severe(message);

        else

          log.info(message);

      }),

    ).addHandler(app);


    var server = await shelf_io.serve(handler, host, port);

    server.autoCompress = true;


    log.info('serving on: $baseUrl');

  }

}


extension on Request {

  Future<String?> bodyJsonValue(String param) async {

    return jsonDecode(await this.readAsString())?[param];

  }

  Future<Map?> bodyJsonMap() async {

    return jsonDecode(await this.readAsString());

  }


  String? get accessToken =>

      this.headers['Authorization']?.split('Bearer ').last;

}


extension JsonMockResponse on Response {

  static ok<T>(T json, {int delay = 800}) async {

    await Future.delayed(Duration(milliseconds: delay)); // Emulate lag

    return Response.ok(

      jsonEncode(json),

      headers: {'Content-Type': 'application/json'},

    );

  }

}
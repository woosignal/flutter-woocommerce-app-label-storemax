import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* ApiService
|--------------------------------------------------------------------------
| Define your API endpoints
| Learn more https://nylo.dev/docs/6.x/networking
|-------------------------------------------------------------------------- */

class ApiService extends NyApiService {
  ApiService({BuildContext? buildContext})
      : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  @override
  final interceptors = {PrettyDioLogger: PrettyDioLogger()};

  Future<dynamic> fetchTestData() async {
    return await network(
      request: (request) => request.get("/endpoint-path"),
    );
  }
}

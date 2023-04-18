// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app_tutorial/common/constants/data.dart';
import 'package:delivery_app_tutorial/common/services/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(CustomInterceptor(storage: storage));

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] [${options.uri}]');
    // print(options.headers); // {accessToken: true}
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({'Authorization': 'Bearer $token'});
    }

    if (options.headers['refreshToken'] == "true") {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({'Authorization': 'Bearer $token'});
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] [${response.requestOptions.uri}]');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print('[ERROR] [${err.requestOptions.method}] [${err.requestOptions.uri}]');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      // 토큰을 Refresh하려는 의도가 아니었을때
      final dio = Dio();
      try {
        final Response res = await dio.post('http://$ip/auth/token',
            options: Options(headers: {
              'Authorization': 'Bearer $refreshToken',
            }));

        final accessToken = res.data['accessToken'];
        final newOptions = err.requestOptions;

        newOptions.headers.addAll({'Authorization': 'Bearer $accessToken'});
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final Response newRes = await dio.fetch(newOptions);
        return handler.resolve(newRes);
      } on DioError catch (e) {
        return handler.reject(e);
      }
    }

    super.onError(err, handler);
  }
}

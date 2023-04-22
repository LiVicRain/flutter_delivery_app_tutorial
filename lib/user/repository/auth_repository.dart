// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app_tutorial/common/models/login_response.dart';
import 'package:delivery_app_tutorial/common/models/token_response.dart';
import 'package:delivery_app_tutorial/common/services/dio/dio.dart';
import 'package:delivery_app_tutorial/common/utils/data_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/data.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(baseUrl: 'http://$ip/auth', dio: dio);
});

class AuthRepository {
  final String baseUrl;
  final Dio dio;
  AuthRepository({
    required this.baseUrl,
    required this.dio,
  });

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final serialized = DataUtils.plainToBase64('$username:$password');

    final res = await dio.post(
      '$baseUrl/login',
      options: Options(
        headers: {
          'Authorization': 'Basic $serialized',
        },
      ),
    );
    return LoginResponse.fromJson(res.data);
  }

  Future<TokenResponse> token() async {
    final res = await dio.post(
      '$baseUrl/token',
      options: Options(
        headers: {
          'refreshToken': 'true',
        },
      ),
    );
    return TokenResponse.fromJson(res.data);
  }
}

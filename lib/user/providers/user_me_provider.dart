// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app_tutorial/common/services/secure_storage/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:delivery_app_tutorial/common/constants/data.dart';
import 'package:delivery_app_tutorial/user/models/user_model.dart';
import 'package:delivery_app_tutorial/user/repository/auth_repository.dart';
import 'package:delivery_app_tutorial/user/repository/user_me_repository.dart';

final userMeProvider =
    StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userMeRepository = ref.watch(userMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
    repository: userMeRepository,
    authRepository: authRepository,
    storage: storage,
  );
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final UserMeRepository repository;
  final AuthRepository authRepository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.repository,
    required this.authRepository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }

    final res = await repository.getMe();

    state = res;
  }

  Future<UserModelBase> login({
    required String userName,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final res = await authRepository.login(
        username: userName,
        password: password,
      );

      await storage.write(key: REFRESH_TOKEN_KEY, value: res.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: res.accessToken);

      final userResponse = await repository.getMe();

      state = userResponse;

      return userResponse;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다');
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
    ]);

    // await storage.delete(key: REFRESH_TOKEN_KEY);
    // await storage.delete(key: ACCESS_TOKEN_KEY);
  }
}

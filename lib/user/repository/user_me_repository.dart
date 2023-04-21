import 'package:delivery_app_tutorial/common/services/dio/dio.dart';
import 'package:delivery_app_tutorial/user/models/user_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/constants/data.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return UserMeRepository(dio, baseUrl: 'http://$ip/user/me');
});

@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio, {String baseUrl}) = _UserMeRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<UserModel> getMe();

  /* 
  {
    "id": "f55b32d2-4d68-4c1e-a3ca-da9d7d0d92e5",
    "username": "test@codefactory.ai",
    "imageUrl": "/img//logo/codefactory_logo.png"
  } 
   */
}

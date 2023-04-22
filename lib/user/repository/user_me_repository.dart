import 'package:delivery_app_tutorial/common/services/dio/dio.dart';
import 'package:delivery_app_tutorial/user/models/basket_item_model.dart';
import 'package:delivery_app_tutorial/user/models/patch_basket_body.dart';
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

  @GET('/basket')
  @Headers({'accessToken': 'true'})
  Future<List<BasketItemModel>> getBasket();

  @PATCH('/basket')
  @Headers({'accessToken': 'true'})
  Future<List<BasketItemModel>> patchBasket({
    @Body() required PatchBasketBody body,
    // PatchBasketBody 의 toJson 이 실행하면 body 값으로 변경되어 들어간다
  });
}

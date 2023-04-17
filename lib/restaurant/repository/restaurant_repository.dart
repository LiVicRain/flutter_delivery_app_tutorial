import 'package:delivery_app_tutorial/common/models/cursor_pagination_model.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_detail_model.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  // 인스턴스를 생성하지 않게 하기 위해 abstract
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // http://$ip/restaurant/
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<Restaurant>>
      paginate(); // abstract 이기 때문에 body를 없앤다. 어떤 함수가 있는지만 적는다

  // http://$ip/restaurant/:id
  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetail> getRestaurantDetail({
    @Path() required String id,
  });
}

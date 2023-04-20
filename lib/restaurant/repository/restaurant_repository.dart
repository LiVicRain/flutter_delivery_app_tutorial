import 'package:delivery_app_tutorial/common/models/cursor_pagination_model.dart';
import 'package:delivery_app_tutorial/common/models/pagination_params.dart';
import 'package:delivery_app_tutorial/common/repository/base_pagination_repository.dart';
import 'package:delivery_app_tutorial/common/services/dio/dio.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_detail_model.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/constants/data.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = RestaurantRepository(
    dio,
    baseUrl: 'http://$ip/restaurant',
  );

  return repository;
});

@RestApi()
abstract class RestaurantRepository
    implements IBasePaginationRespository<RestaurantModel> {
  // 인스턴스를 생성하지 않게 하기 위해 abstract
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // http://$ip/restaurant/
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
  // build 타임 constant 이기 때문에 cosnt 를 넣어줘야 한다

  // http://$ip/restaurant/:id
  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}

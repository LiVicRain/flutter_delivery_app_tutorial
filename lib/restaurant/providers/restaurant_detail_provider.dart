import 'package:delivery_app_tutorial/common/models/cursor_pagination_model.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_model.dart';
import 'package:delivery_app_tutorial/restaurant/providers/restaurant_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  // 데이터가 없을 때
  if (state is! CursorPagination<dynamic>) {
    return null;
  }

  return state.data.firstWhereOrNull((element) => element.id == id);

  // firstWhere 는 존재하지 않으면 error 를 던진다
  // 존재하지 않을 경우 null 를 던지련 collection 패키지의 firstWhereOrNull를 해야 한다
});

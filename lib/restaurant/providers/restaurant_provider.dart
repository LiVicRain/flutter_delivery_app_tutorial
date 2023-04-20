import 'package:delivery_app_tutorial/common/models/pagination_params.dart';
import 'package:delivery_app_tutorial/common/providers/pagination_provider.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_detail_model.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_model.dart';
import 'package:delivery_app_tutorial/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/models/cursor_pagination_model.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);
    return notifier;
  },
);

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    // 데이터가 없는 상태일때 CursorPagination 이 아닐때
    if (state is! CursorPagination) {
      await paginate();
    }

    // paginate()를 했는데도 CursorPagination 이 아닐때
    if (state is! CursorPagination) {
      return null;
    }

    final pState = state as CursorPagination;

    // id 에 해당이 되는 상세값을 가져와야 한다
    final res = await repository.getRestaurantDetail(id: id);
    // res에는 이미 id 에 해당되는 RestaurantDetailModel 이 들어갔다
    // 이제 이걸로 해야하는것은 pState 안에 id에 해당되는 모델을 찾은다음에
    // res으로  대체를 해줘야 한다 그 이유는 pState 에 id 에 해당되는 데이터는
    // 그냥 RestaurantModel 이기 때문이다 그래서 RestaurantDetailModel 인 res 로 대체를 해줘야 한다

    // 만약 RestaurantModel id 가 1, 2, 3 만 있을때 10을 요청하는 경우
    // 데이터가 없을때 그냥 캐시의 끝에다가 데이터를 추가해버린다
    if (pState.data.where((element) => element.id == id).isEmpty) {
      // 존재하지 않을 경우
      state = pState.copyWith(
        data: <RestaurantModel>[...pState.data, res],
      );
    } else {
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>((e) => e.id == id ? res : e)
            .toList(),
      );
    }
  }
}

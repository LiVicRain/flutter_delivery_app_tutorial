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

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }
  // 생성자 body 안에 paginate() 넣어주면
  // RestaurantStateNotifier 이 생성이 될때 바로 실행이 된다

  // 실제 pageination을 진행하고 값을 반환하는것이 아니라
  // 상태 안에 응답받은 레스토랑 모델을 집어 넣을 것이다
  paginate({
    int fetchCount = 20,

    // true 일때 추가로 데이터 더 가져오기
    // false 일때 새로고침 (현재 상태를 덮어씌움)
    bool fetchMore = false,

    // 강제로 다시 로딩하기
    bool forceRefetch = false,
  }) async {
    // 5자기의 가능성 state 의 상태

    // 1) CursorPagination - 정상적으로 데이터가 있는 상태

    // 2) CursorPaginationLoading - 데이터가 로딩 중인 상태 (현재 캐시 없음)

    // 3) CursorPagiantionError - 에러가 있는 상태

    // 4) CursorPaginationRefetching - 데이터 새로고침

    // 5) CursorPaginationFetchMore - 추가 데이터를 가져올때

  }
}

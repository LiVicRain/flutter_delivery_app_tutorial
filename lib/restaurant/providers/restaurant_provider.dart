import 'package:delivery_app_tutorial/common/models/pagination_params.dart';
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
  Future<void> paginate({
    int fetchCount = 20,

    // true 일때 추가로 데이터 더 가져오기
    // false 일때 새로고침 (현재 상태를 덮어씌움)
    bool fetchMore = false,

    // 강제로 처음부터 다시 로딩하기
    bool forceRefetch = false,
  }) async {
    try {
      // 5자기의 가능성 state 의 상태
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩 중인 상태 (현재 캐시 없음)
      // 3) CursorPagiantionError - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 데이터 새로고침
      // 5) CursorPaginationFetchMore - 추가 데이터를 가져올때

      // 바로 반환하는 상황 paginate 를 실행할 필요가 없을때
      // 1) hasMore = false
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2) 로딩중 일때 - fetchMore 가 true 일때
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // 데이터를 추가로 더 가져와야 하는 상황
      if (fetchMore) {
        // fetchMore 가 되는 상황이면 이미 화면이 보여지는 CursorPagination 상태가 extends 하고 있는 상황이다
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      }
      // 데이터를 처음부터 가져와야 하는 상황
      else {
        // 만약 데이터가 있는 상황이라면 기존 데이터를 보존한 채로 API 요청
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;
          // 데이터는 있는데 새로고침을 하고 있다는 내용
          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          // forceRefetch == true
          // 나머지 상황 데이터를 유지할 필요가 없는 상황일때는 로딩창을 띄우자
          state = CursorPaginationLoading();
        }
      }

      // repository.paginate() 이 CursorPagination<RestaurantModel> 반환
      // 가장 최근 데이터를 가져옴
      final res = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        // CursorPagination<RestaurantModel>
        // meta 는 그대로
        // data 는 기존에 있던 data 와 가장 최근의 data 를 합쳐줘야 한다
        // 스프레드 연산자를 사용해서 합춰준다
        state = res.copyWith(data: [
          ...pState.data,
          ...res.data,
        ]);
      } else {
        // 로딩이거나 리페칭 일때
        state = res;
        // 이유는 res 는 맨 처음 가져온 응답값이다
        // paginationParams 안에 after 값을 넣어주지 않았기 떄문
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다');
    }
  }

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

    state = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>((e) => e.id == id ? res : e)
          .toList(),
    );
  }
}

import 'package:delivery_app_tutorial/restaurant/models/restaurant_model.dart';
import 'package:delivery_app_tutorial/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, List<RestaurantModel>>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);
    return notifier;
  },
);

class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super([]) {
    paginate();
  }
  // 생성자 body 안에 paginate() 넣어주면
  // RestaurantStateNotifier 이 생성이 될때 바로 실행이 된다

  // 실제 pageination을 진행하고 값을 반환하는것이 아니라
  // 상태 안에 응답받은 레스토랑 모델을 집어 넣을 것이다
  paginate() async {
    final res =
        await repository.paginate(); // CursorPagination<RestaurantModel>>
    state = res.data;

    // res == CursorPagination<RestaurantModel>>
    // res.data == List<RestaurantModel>
  }
}

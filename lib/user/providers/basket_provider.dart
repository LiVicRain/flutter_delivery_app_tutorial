import 'package:delivery_app_tutorial/product/models/product_model.dart';
import 'package:delivery_app_tutorial/user/models/basket_item_model.dart';
import 'package:delivery_app_tutorial/user/models/patch_basket_body.dart';
import 'package:delivery_app_tutorial/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart'; // null 체크를 하기 위함

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);
  return BasketProvider(repository: repository);
});

// BasketProvider 는 장바구니 아이템을 관리한다
class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketProvider({required this.repository}) : super([]);

  Future<void> patchBasket() async {
    await repository.patchBasket(
        body: PatchBasketBody(
            basket: state
                .map((e) => PatchBasketBodyBasket(
                      productId: e.product.id,
                      count: e.count,
                    ))
                .toList()));
  }

  // 장바구니 아이템 추가하기
  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 1) 아직 장바구니에 해당되는 상품이 없다면 장바구니에 상품을 추가한다

    // 2) 이미 해당 상품이 들어있다면 장바구니에 있는 count에 더한다

    // collection 패키지의 firstWhereOrNull 값이 없을 때 null 를 반환
    final bool exists =
        state.firstWhereOrNull((element) => element.product.id == product.id) !=
            null;

    if (exists) {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count + 1) : e)
          .toList();
    } else {
      state = [...state, BasketItemModel(product: product, count: 1)];
    }

    // 실제 네트워크 작업
    await patchBasket();
  }

  // 장바구니 삭제
  Future<void> removeFromBasket({
    required ProductModel product,
    bool isDelete = false, // true 면 카운트와 관계 없이 삭제한다
  }) async {
    // 1) 장바구니 상품이 존재할때 count가 1보다 크면 -1, count 가 1이면 삭제한다
    // 2) 상품이 존재하지 않을때 즉시 return 한다

    final bool exists =
        state.firstWhereOrNull((element) => element.product.id == product.id) !=
            null;

    if (!exists) {
      return;
    }

    final BasketItemModel existingProduct =
        state.firstWhere((element) => element.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
      state =
          state.where((element) => element.product.id != product.id).toList();
    } else {
      state = state
          .map((e) =>
              e.product.id == product.id ? e.copyWith(count: e.count - 1) : e)
          .toList();
    }

    await patchBasket();
  }
}

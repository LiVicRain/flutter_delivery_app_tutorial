// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app_tutorial/common/constants/colors.dart';
import 'package:delivery_app_tutorial/common/models/cursor_pagination_model.dart';
import 'package:delivery_app_tutorial/common/utils/pagination_utils.dart';
import 'package:delivery_app_tutorial/product/models/product_model.dart';
import 'package:delivery_app_tutorial/rating/components/rating_card.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_detail_model.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_model.dart';
import 'package:delivery_app_tutorial/restaurant/providers/restaurant_detail_provider.dart';
import 'package:delivery_app_tutorial/restaurant/providers/restaurant_provider.dart';
import 'package:delivery_app_tutorial/restaurant/providers/restaurant_rating_provider.dart';
import 'package:delivery_app_tutorial/user/providers/basket_provider.dart';
import 'package:flutter/material.dart';

import 'package:delivery_app_tutorial/common/layouts/default_layout.dart';
import 'package:delivery_app_tutorial/product/components/product_card.dart';
import 'package:delivery_app_tutorial/restaurant/components/restaurant_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';
import 'package:badges/badges.dart' as badges;

import '../../rating/models/rating_model.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantDetail';
  final String id;

  const RestaurantDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    _scrollController.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
        scrollController: _scrollController,
        provider: ref.read(restaurantRatingProvider(widget.id).notifier));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return const DefaultLayout(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }

    return DefaultLayout(
      title: state.name,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _renderTop(restaurant: state),
          if (state is! RestaurantDetailModel) _renderLoading(),
          if (state is RestaurantDetailModel) _renderLabel(),
          if (state is RestaurantDetailModel)
            _renderProduct(products: state.products, restaurant: state),
          if (ratingsState is CursorPagination<RatingModel>)
            _renderRatings(models: ratingsState.data),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: uPrimaryColor,
        onPressed: () {},
        child: badges.Badge(
          showBadge: basket.isNotEmpty,
          badgeStyle: const badges.BadgeStyle(
            badgeColor: Colors.white,
          ),
          badgeAnimation: const badges.BadgeAnimation.scale(),
          badgeContent: Text(
            basket
                .fold(
                  0,
                  (previousValue, element) => previousValue + element.count,
                )
                .toString(), // 매번 값을 더해 total 값을 넣는다
            style: const TextStyle(color: uPrimaryColor, fontSize: 10.0),
            textAlign: TextAlign.center,
          ),
          child: const Icon(Icons.shopping_basket_outlined),
        ),
      ),
    );
  }

  SliverPadding _renderRatings({
    required List<RatingModel> models,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.all(15),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: RatingCard.fromModel(model: models[index]),
                ),
            childCount: models.length),
      ),
    );
  }

  SliverPadding _renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 15.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
              3,
              (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: SkeletonParagraph(
                      style: const SkeletonParagraphStyle(
                        lines: 5,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  )),
        ),
      ),
    );
  }

  SliverPadding _renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      sliver: SliverToBoxAdapter(
        child: Text(
          "메뉴",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  SliverPadding _renderProduct({
    required List<RestaurantProduct> products,
    required RestaurantModel restaurant,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];

            return InkWell(
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                      product: ProductModel(
                        id: model.id,
                        name: model.name,
                        detail: model.detail,
                        imgUrl: model.imgUrl,
                        price: model.price,
                        restaurant: restaurant,
                      ),
                    );
              },
              child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ProductCard.fromRestaurantProductModel(
                      restaurantProduct: model)),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter _renderTop({
    required RestaurantModel restaurant,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        restaurant: restaurant,
        isDetail: true,
      ),
    );
  }
}

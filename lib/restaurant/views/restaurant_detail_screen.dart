// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app_tutorial/common/services/dio/dio.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_detail_model.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_model.dart';
import 'package:delivery_app_tutorial/restaurant/providers/restaurant_detail_provider.dart';
import 'package:delivery_app_tutorial/restaurant/providers/restaurant_provider.dart';
import 'package:flutter/material.dart';

import 'package:delivery_app_tutorial/common/layouts/default_layout.dart';
import 'package:delivery_app_tutorial/product/components/product_card.dart';
import 'package:delivery_app_tutorial/restaurant/components/restaurant_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
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
  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));

    if (state == null) {
      return const DefaultLayout(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }

    return DefaultLayout(
      title: state.name,
      body: CustomScrollView(
        slivers: [
          _renderTop(restaurant: state),
          if (state is RestaurantDetailModel) _renderLabel(),
          if (state is RestaurantDetailModel)
            _renderProduct(products: state.products),
        ],
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
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];

            return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ProductCard.fromModel(restaurantProduct: model));
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

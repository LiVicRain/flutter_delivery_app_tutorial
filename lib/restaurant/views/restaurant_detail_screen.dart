// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app_tutorial/restaurant/models/restaurant_detail_model.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:delivery_app_tutorial/common/layouts/default_layout.dart';
import 'package:delivery_app_tutorial/product/components/product_card.dart';
import 'package:delivery_app_tutorial/restaurant/components/restaurant_card.dart';

import '../../common/constants/data.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  Future<Map<String, dynamic>> getRestaurantDetail() async {
    final dio = Dio();
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final res = await dio.get(
      'http://$ip/restaurant/$id',
      options: Options(headers: {
        'Authorization': 'Bearer $accessToken',
      }),
    );

    return res.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: "붙타는 떡볶이",
        body: FutureBuilder<Map<String, dynamic>>(
          future: getRestaurantDetail(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final item = RestaurantDetail.fromJson(json: snapshot.data!);
            return CustomScrollView(
              slivers: [
                _renderTop(restaurant: item),
                _renderLabel(),
                _renderProduct(products: item.products),
              ],
            );
          },
        ));
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
    required Restaurant restaurant,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        restaurant: restaurant,
        isDetail: true,
      ),
    );
  }
}

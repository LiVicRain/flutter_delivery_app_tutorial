import 'package:delivery_app_tutorial/common/components/pagination_list_view.dart';
import 'package:delivery_app_tutorial/product/components/product_card.dart';
import 'package:delivery_app_tutorial/product/models/product_model.dart';
import 'package:delivery_app_tutorial/product/providers/product_provider.dart';
import 'package:delivery_app_tutorial/restaurant/views/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      provider: productProvider,
      itemBuilder: <ProductModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            context.goNamed(
              RestaurantDetailScreen.routeName,
              params: {
                'rid': model.restaurant.id,
              },
            );
          },
          child: ProductCard.fromProductModel(model: model),
        );
      },
    );
  }
}

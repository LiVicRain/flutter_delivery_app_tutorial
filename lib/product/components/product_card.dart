// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app_tutorial/product/models/product_model.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_detail_model.dart';
import 'package:flutter/material.dart';

import 'package:delivery_app_tutorial/common/constants/colors.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard({
    Key? key,
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
  }) : super(key: key);

  factory ProductCard.fromProductModel({
    required ProductModel model,
  }) {
    return ProductCard(
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
    );
  }

  factory ProductCard.fromRestaurantProductModel({
    required RestaurantProduct restaurantProduct,
  }) {
    return ProductCard(
      image: Image.network(
        restaurantProduct.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: restaurantProduct.name,
      detail: restaurantProduct.detail,
      price: restaurantProduct.price,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: image,
          ),
          const SizedBox(width: 15),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
              Text(
                detail,
                style: const TextStyle(color: uFontBodyColor, fontSize: 14.0),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '₩ $price',
                style: const TextStyle(
                  color: uPrimaryColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ))
        ],
      ),
    );
  }
}

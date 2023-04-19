// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app_tutorial/restaurant/models/restaurant_detail_model.dart';
import 'package:flutter/material.dart';

import 'package:delivery_app_tutorial/common/constants/colors.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final Widget image;
  final String name;
  final List<String> tags; // 레스토랑 태그
  final int ratingsCount; // 평점 갯수
  final int deliveryTime; //  배송걸리는 시간
  final int deliveryFee; // 배송 비용
  final double ratings; // 평점
  final bool isDetail;
  final String? detail;

  const RestaurantCard({
    Key? key,
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
    this.isDetail = false,
    this.detail,
  }) : super(key: key);

  factory RestaurantCard.fromModel({
    required RestaurantModel restaurant,
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(
        restaurant.thumbUrl,
        fit: BoxFit.cover,
      ),
      name: restaurant.name,
      tags: restaurant.tags,
      ratingsCount: restaurant.ratingsCount,
      deliveryTime: restaurant.deliveryTime,
      deliveryFee: restaurant.deliveryFee,
      ratings: restaurant.ratings,
      isDetail: isDetail,
      detail: restaurant is RestaurantDetail ? restaurant.detail : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isDetail) image,
        if (!isDetail)
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: image,
          ),
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 15 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Text(
                tags.join(' · '),
                style: const TextStyle(
                  color: uFontBodyColor,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  _IconText(icon: Icons.star, label: ratings.toString()),
                  _renderDot(),
                  _IconText(
                      icon: Icons.receipt, label: ratingsCount.toString()),
                  _renderDot(),
                  _IconText(
                      icon: Icons.timelapse_outlined, label: "$deliveryTime 분"),
                  _renderDot(),
                  _IconText(
                      icon: Icons.monetization_on,
                      label: deliveryFee == 0 ? "무료" : deliveryFee.toString()),
                ],
              ),
              if (isDetail && detail != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(detail!),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

_renderDot() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 2),
    child: Text(
      ' · ',
      style: TextStyle(
          fontSize: 12.0, fontWeight: FontWeight.w500, color: uFontBodyColor),
    ),
  );
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconText({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: uPrimaryColor,
          size: 14,
        ),
        const SizedBox(width: 8.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

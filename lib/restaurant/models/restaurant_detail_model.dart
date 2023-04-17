// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app_tutorial/common/utils/data_utils.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_detail_model.g.dart';

@JsonSerializable()
class RestaurantDetail extends Restaurant {
  final String detail;
  final List<RestaurantProduct> products;

  RestaurantDetail({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      _$RestaurantDetailFromJson(json);

  // factory RestaurantDetail.fromJson({required Map<String, dynamic> json}) {
  //   return RestaurantDetail(
  //     id: json['id'],
  //     name: json['name'],
  //     thumbUrl: 'http://$ip${json['thumbUrl']}',
  //     tags: List<String>.from(json['tags']),
  //     priceRange: RestaurantPriceRange.values
  //         .firstWhere((element) => element.name == json['priceRange']),
  //     ratings: json['ratings'],
  //     ratingsCount: json['ratingsCount'],
  //     deliveryTime: json['deliveryTime'],
  //     deliveryFee: json['deliveryFee'],
  //     detail: json['detail'],
  //     products: json['products']
  //         .map<RestaurantProduct>((x) => RestaurantProduct.fromJson(json: x))
  //         .toList(),
  //   );
  // }
}

@JsonSerializable()
class RestaurantProduct {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;
  RestaurantProduct({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProduct.fromJson(Map<String, dynamic> json) =>
      _$RestaurantProductFromJson(json);

  // factory RestaurantProduct.fromJson({required Map<String, dynamic> json}) {
  //   return RestaurantProduct(
  //     id: json['id'],
  //     name: json['name'],
  //     imgUrl: 'http://$ip/${json['imgUrl']}',
  //     detail: json['detail'],
  //     price: json['price'],
  //   );
  // }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app_tutorial/common/models/model_with_id.dart';
import 'package:delivery_app_tutorial/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/constants/data.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange { expensive, medium, cheap }

@JsonSerializable()
class RestaurantModel implements IModelWithId {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  // 현재 인스턴스를 JSON으로 자동으로 바꿔줌
  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  // factory Restaurant.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return Restaurant(
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
  //   );
  // }
}

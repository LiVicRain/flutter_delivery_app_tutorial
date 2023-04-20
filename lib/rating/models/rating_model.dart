// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:delivery_app_tutorial/common/utils/data_utils.dart';
import 'package:delivery_app_tutorial/user/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rating_model.g.dart';

@JsonSerializable()
class RatingModel {
  final String id;
  final UserModel user;
  final int rating;
  final String content;
  @JsonKey(
    fromJson: DataUtils.listPathToUrls,
  )
  final List<String> imgUrls;
  RatingModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.content,
    required this.imgUrls,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);
}

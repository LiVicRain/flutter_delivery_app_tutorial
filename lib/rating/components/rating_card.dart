// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:delivery_app_tutorial/common/constants/colors.dart';
import 'package:collection/collection.dart';

class RatingCard extends StatelessWidget {
  // ImageProvider 는 NetworkImage, AssetImage 이런 위젯들
  // CircleAvatar 에 넣어야 해서 이렇게 받는것이다
  final ImageProvider avatarImage;
  final List<Image> images;
  final int rating;
  final String email;
  final String content;

  const RatingCard({
    Key? key,
    required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(avatarImage: avatarImage, rating: rating, email: email),
        const SizedBox(height: 8),
        _Body(
          content: content,
        ),
        if (images.isNotEmpty)
          SizedBox(
            height: 100,
            child: _Images(
              images: images,
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final int rating;
  final String email;

  const _Header({
    Key? key,
    required this.avatarImage,
    required this.rating,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: avatarImage,
          radius: 12.0,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border_outlined,
            color: index < rating ? uPrimaryColor : Colors.grey[350],
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;
  const _Body({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: const TextStyle(
              color: uFontBodyColor,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .mapIndexed(
            (index, e) => Padding(
              padding:
                  EdgeInsets.only(right: index == images.length - 1 ? 0 : 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: e,
              ),
            ),
          )
          .toList(),
    );
  }
}

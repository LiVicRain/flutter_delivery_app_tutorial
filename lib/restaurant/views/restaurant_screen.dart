import 'package:delivery_app_tutorial/common/models/cursor_pagination_model.dart';
import 'package:delivery_app_tutorial/restaurant/components/restaurant_card.dart';
import 'package:delivery_app_tutorial/restaurant/models/restaurant_model.dart';
import 'package:delivery_app_tutorial/restaurant/providers/restaurant_provider.dart';
import 'package:delivery_app_tutorial/restaurant/repository/restaurant_repository.dart';
import 'package:delivery_app_tutorial/restaurant/views/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 캐스팅
    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.separated(
        itemCount: cp.data.length,
        itemBuilder: (context, index) {
          final pItem = cp.data[index];

          return GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(
                id: pItem.id,
              ),
            )),
            child: RestaurantCard.fromModel(restaurant: pItem),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
      ),
    );
  }
}

import 'package:delivery_app_tutorial/common/models/cursor_pagination_model.dart';
import 'package:delivery_app_tutorial/common/utils/pagination_utils.dart';
import 'package:delivery_app_tutorial/restaurant/components/restaurant_card.dart';
import 'package:delivery_app_tutorial/restaurant/providers/restaurant_provider.dart';
import 'package:delivery_app_tutorial/restaurant/views/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      scrollListener();
    });
  }

  void scrollListener() {
    PaginationUtils.paginate(
        scrollController: _scrollController,
        provider: ref.read(restaurantProvider.notifier));
/*     // 현재 위치가 최대 길이보다 조금 덜되는 위치까지 왔다면
    // 새로운 데이터를 추가요청
    if (_scrollController.offset >
        _scrollController.position.maxScrollExtent - 300) {
      // _scrollController.position.maxScrollExtent 은 스크롤이 될 수 있는 최대 위치
      // 여기에 -300 은 바닥에 300px 만큼 떨어져 있을때 를 의미한다
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    } */
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    // 완전 처음 로딩일때
    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러일때
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // CursorPagination -> 데이터 표시
    // CursorPaginationFetchingMore -> 데이터 더 가져오기
    // CursorPaginationRefetching -> 데이터 새로고침

    // 캐스팅
    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.separated(
        controller: _scrollController,
        itemCount: cp.data.length + 1,
        itemBuilder: (context, index) {
          if (index == cp.data.length) {
            // index == cp.data.length 는 마지막을 의미 data 는 0부터 시작
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Center(
                child: data is CursorPaginationFetchingMore
                    ? const CircularProgressIndicator()
                    : const Text('마지막 데이터입니다'),
              ),
            );
          }
          final pItem = cp.data[index];

          return GestureDetector(
            onTap: () => context.goNamed(
              RestaurantDetailScreen.routeName,
              params: {
                'rid': pItem.id,
              },
              queryParams: {},
            ),
            child: RestaurantCard.fromModel(restaurant: pItem),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
      ),
    );
  }
}

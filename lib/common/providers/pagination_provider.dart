import 'package:delivery_app_tutorial/common/models/cursor_pagination_model.dart';
import 'package:delivery_app_tutorial/common/models/model_with_id.dart';
import 'package:delivery_app_tutorial/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pagination_params.dart';

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRespository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;

  // <U extends IBasePaginationRespository> 는
  // U 타입은 IBasePaginationRespository 를 상속한 타입다를 알려준다
  // 제너릭에서는 implments 가 아닌 extends 를 사용해야 한다

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      if (fetchMore) {
        final pState = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorPaginationLoading();
        }
      }

      final res = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;
        state = res.copyWith(data: [
          ...pState.data,
          ...res.data,
        ]);
      } else {
        state = res;
      }
    } catch (e, stack) {
      print('error 가 발생했습니다 : $e');
      print('stack : $stack');
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다');
    }
  }
}

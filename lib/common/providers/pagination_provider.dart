import 'package:delivery_app_tutorial/common/models/cursor_pagination_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pagination_params.dart';

class PaginationProvider extends StateNotifier<CursorPaginationBase> {
  final  repository;

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading());

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
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;
          state = CursorPaginationRefetching(
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
        final pState = state as CursorPaginationFetchingMore;
        state = res.copyWith(data: [
          ...pState.data,
          ...res.data,
        ]);
      } else {
        state = res;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다');
    }
  }
}

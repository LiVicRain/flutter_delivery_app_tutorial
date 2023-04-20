// I 는 인터페이스라는 뜻
import 'package:delivery_app_tutorial/common/models/model_with_id.dart';

import '../../rating/models/rating_model.dart';
import '../models/cursor_pagination_model.dart';
import '../models/pagination_params.dart';

abstract class IBasePaginationRespository<T extends IModelWithId> {
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}

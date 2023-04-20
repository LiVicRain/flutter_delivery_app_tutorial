// ignore_for_file: public_member_api_docs, sort_constructors_first
// CursorPaginationFetchingMore 와 같은 클래스에서 값이 없으므로 data 를 dynamic 으로 취급한다
// T 값을 넣어줘야지 데이터가 이를 판단한다, 이는 좋지 않다 정확한 모델을 넣어줘야 함으로
// 모델 또한 일반화 해야 한다 -> id 값이 있다는것을 증명해야 한다
// 일반화된 모델
abstract class IModelWithId {
  final String id;
  IModelWithId({
    required this.id,
  });
}
// IModelWithId 를 implements 한 모델들은 무조건 id 가 있다는것을 정의한다
import '../constants/data.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }

  static List<String> listPathToUrls(List<dynamic> paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }
  // 서버에서 오는 데이터를 dynamic 타입이라고 가정하고 String 타입으로 변환해주자
}
 
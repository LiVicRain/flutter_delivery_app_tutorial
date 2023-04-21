import 'dart:convert';

import '../constants/data.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }

  static List<String> listPathToUrls(List<dynamic> paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }
  // 서버에서 오는 데이터를 dynamic 타입이라고 가정하고 String 타입으로 변환해주자

  static String plainToBase64(String plain) {
    //base64로 인코딩
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(plain);

    return encoded;
  }
}

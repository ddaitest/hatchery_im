import 'dart:math';

class ApiResult {
  int code = 0;
  String info = "";
  Map<String, dynamic> parsed;

  ApiResult(this.parsed) {
    code = parsed['code'];
    info = parsed['info'];
  }

  factory ApiResult.of(Map<String, dynamic> response) {
    return ApiResult(response);
  }

  factory ApiResult.error(e) {
    return ApiResult({'code': 0, 'info': e.toString()});
  }

  bool isSuccess() {
    return code == 1000;
  }

  dynamic getData() {
    return parsed['result'];
  }

  List<O> getDataList<O, I>(O function(Map<String, dynamic> value),
      {int type = 0}) {
    var data;
    if (type != 0) {
      data = getData()['datas'];
    } else {
      data = getData();
    }
    if (data == null) {
      return <O>[];
    } else {
      return (data as List<dynamic>).map((m) => function(m)).toList();
    }
  }
}

import 'package:flutter_rapid_development_maker/src/asset/sp_maker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('读取目录下的文件', () {
    SpMaker.makeAndSave(modelClassName: "UserInfoModel");
    print("执行完毕！！！");
  });
}

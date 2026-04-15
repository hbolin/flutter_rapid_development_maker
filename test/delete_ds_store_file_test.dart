import 'dart:io';

import 'package:flutter_rapid_development_maker/src/asset/delete_ds_store_file.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('验证删除 .DS_Store 文件逻辑', () {
    deleteDsStoreFile(Directory.current);
    print("执行完毕！！！");
  });
}

import 'dart:io';

import 'package:flutter_rapid_development_maker/src/base/read_directory_files.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('读取目录下的文件', () {
    List<DirectoryUnderFiles> directoryUnderFiles = readDirectoryFiles(Directory.current.path);
    print(directoryUnderFiles.map((e) => "$e").join("\n------------------------------------------------------------------------------------------------------\n"));
    print("执行完毕！！！");
  });
}

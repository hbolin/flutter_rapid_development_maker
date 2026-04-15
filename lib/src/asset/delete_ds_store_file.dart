import 'dart:io';

import 'package:path/path.dart' as path;

void deleteDsStoreFile(Directory directory) {
  if (!directory.existsSync()) {
    return;
  }

  // 使用 recursive: true 自动递归遍历所有子目录
  // followLinks: false 防止误入符号链接导致死循环
  for (var entity in directory.listSync(recursive: true, followLinks: false)) {
    // 检查是否为文件且文件名匹配
    if (entity is File && path.basename(entity.path) == ".DS_Store") {
      try {
        entity.deleteSync();
        print("以下文件已删除：${entity.path}");
      } catch (e) {
        print("删除失败 ${entity.path}: $e");
      }
    }
  }
}

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

/// 递归读取[directoryPath]目录下的所有文件
List<DirectoryUnderFiles> readDirectoryFiles(String directoryPath) {
  List<DirectoryUnderFiles> result = [];
  _readDirectoryFiles(directoryPath, result);
  return result;
}

void _readDirectoryFiles(String directoryPath, List<DirectoryUnderFiles> result) {
  var directory = Directory(directoryPath);
  if (directory.existsSync() != true) {
    throw "目录不存在：$directoryPath";
  }
  // 1. 获取列表时直接处理
  final List<FileSystemEntity> entities;
  try {
    entities = directory.listSync(followLinks: false);
  } catch (e) {
    throw ("无法读取目录 $directoryPath: $e");
  }

  // 2. 使用类型判断代替路径判断，减少磁盘 IO
  var files = entities
      .whereType<File>()
      .where((file) => !path.basename(file.path).startsWith('.')) // 过滤隐藏文件如 .DS_Store
      .sortedBy((f) => f.fileNameWithoutExtension);

  // 递归处理子目录
  final subDirectories = entities
      .whereType<Directory>()
      .where((d) => !path.basename(d.path).startsWith('.')) // 通常子目录也需要过滤隐藏项
      .sortedBy((d) => d.directoryName);

  result.add(DirectoryUnderFiles(directory, files));

  for (var subDir in subDirectories) {
    _readDirectoryFiles(subDir.path, result);
  }
}

/// 目录下的文件
class DirectoryUnderFiles {
  /// 目录
  final Directory directory;

  /// 文件集合
  final List<File> files;

  DirectoryUnderFiles(this.directory, this.files);

  @override
  String toString() {
    return '目录:  \n${directory.path}\n文件:\n${files.map((e) => e.path).join("\n")}';
  }
}

// ---------------------------------------------------- extension ----------------------------------------------------

extension FrdkDirectoryExtension on Directory {
  /// 目录名
  String get directoryName {
    return path.basenameWithoutExtension(this.path);
  }
}

extension FrdkFileExtension on File {
  /// 文件名，不包括后缀
  String get fileNameWithoutExtension {
    return path.basenameWithoutExtension(this.path);
  }

  /// 文件名
  String get fileName {
    return path.basename(this.path);
  }
}

extension FrdkStringExtension on String {
  /// 首字母大写
  String toUpperCaseFirstLetter() {
    if (isEmpty) {
      return this;
    }
    var charList = toCharList();
    return "${charList.first.toUpperCase()}${charList.sublist(1, charList.length).join()}";
  }

  /// 首字母小写
  String toLowerCaseFirstLetter() {
    if (isEmpty) {
      return this;
    }
    var charList = toCharList();
    return "${charList.first.toLowerCase()}${charList.sublist(1, charList.length).join()}";
  }

  /// 将字符串拆分为单个字符组成的列表
  List<String> toCharList() {
    return runes.map((e) => String.fromCharCode(e)).toList();
  }
}

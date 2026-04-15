import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

import 'read_directory_files.dart';

class PubspecEditor {
  /// 添加 image assets 节点数据
  static void addImageAssetsNode(String imageAssetsPath, String projectPubspecYamlPath) {
    final projectPubspecYamlFile = File(projectPubspecYamlPath);
    if (projectPubspecYamlFile.existsSync() != true) {
      throw "项目的pubspec.yaml的文件，不存在：$projectPubspecYamlPath";
    }

    final content = projectPubspecYamlFile.readAsStringSync();
    final yamlEditor = YamlEditor(content);

    // 获取当前内容用于检查
    final yaml = loadYaml(content);

    List<DirectoryUnderFiles> imageAssetsList = readDirectoryFiles(imageAssetsPath);
    imageAssetsList = imageAssetsList.where((element) => element.files.isNotEmpty).toList();
    if (imageAssetsList.isEmpty) {
      throw "没有图片资源：$imageAssetsPath";
    }

    var projectRoot = path.dirname(projectPubspecYamlPath);

    // 将路径转换为相对于项目根目录的相对路径，并统一使用正斜杠
    var relativePaths = imageAssetsList.map((element) {
      var relative = path.relative(element.directory.path, from: projectRoot);
      return "${path.posix.joinAll(path.split(relative))}/";
    }).toList();

    // 1. 获取已有的 assets 列表
    // 使用 ?. 语法安全访问，如果不存在则默认为空列表
    final YamlList? existingAssets = yaml['flutter']?['assets'];

    if (existingAssets == null) {
      print("若无 assets，则创建（支持空节点、仅 flutter 节点存在或都不存在的情况）");
      yamlEditor.update(['flutter', 'assets'], relativePaths);
    } else {
      final assetList = existingAssets.map((e) => e.toString()).toList();
      print("已存在的节点:$assetList");

      // 若已存在，则追加新路径
      for (var newAsset in relativePaths) {
        if (assetList.contains(newAsset) != true) {
          yamlEditor.appendToList(['flutter', 'assets'], newAsset);
          print('已成功追加: $newAsset');
        } else {
          print('路径 $newAsset 已存在，跳过添加');
        }
      }
    }

    projectPubspecYamlFile.writeAsStringSync(yamlEditor.toString());

    print("添加 image assets 节点数据成功！！！");
  }

  /// 添加 font assets 节点数据
  static void addFontAssetsNode(String fontAssetsPath, String projectPubspecYamlPath) {
    final projectPubspecYamlFile = File(projectPubspecYamlPath);
    if (projectPubspecYamlFile.existsSync() != true) {
      throw "项目的pubspec.yaml的文件，不存在：$projectPubspecYamlPath";
    }

    final content = projectPubspecYamlFile.readAsStringSync();
    final yamlEditor = YamlEditor(content);

    // 获取当前内容用于检查
    final yaml = loadYaml(content);

    List<DirectoryUnderFiles> fontAssetsList = readDirectoryFiles(fontAssetsPath);
    fontAssetsList = fontAssetsList.where((element) => element.files.isNotEmpty).toList();
    if (fontAssetsList.isEmpty) {
      throw "没有字体资源：$fontAssetsPath";
    }

    var projectRoot = path.dirname(projectPubspecYamlPath);

    // 将路径转换为相对于项目根目录的相对路径，并统一使用正斜杠
    var relativePaths = fontAssetsList.expand((element) => element.files).map((element) {
      var relative = path.relative(element.path, from: projectRoot);
      return path.posix.joinAll(path.split(relative));
    }).toList();

    // 1. 获取已有的 assets 列表
    // 使用 ?. 语法安全访问，如果不存在则默认为空列表
    final YamlList? existingAssets = yaml['flutter']?['fonts'];

    if (existingAssets == null) {
      print("若无 assets，则创建（支持空节点、仅 flutter 节点存在或都不存在的情况）");
      yamlEditor.update(
        ['flutter', 'fonts'],
        relativePaths.map((element) {
          return {
            "family": File(element).fileNameWithoutExtension,
            "fonts": [
              {"asset": element},
            ],
          };
        }).toList(),
      );
    } else {
      // 若已存在，则追加新路径
      for (var newAsset in relativePaths) {
        // 检查是否有相同的 family 名字
        final bool alreadyExists = existingAssets.any((font) => (font is Map) && (font["family"] == File(newAsset).fileNameWithoutExtension));

        if (alreadyExists != true) {
          final newFont = {
            "family": File(newAsset).fileNameWithoutExtension,
            "fonts": [
              {"asset": newAsset},
            ],
          };
          yamlEditor.appendToList(['flutter', 'fonts'], newFont);
          print('已成功追加: $newFont');
        } else {
          print('路径 $newAsset 已存在，跳过添加');
        }
      }
    }

    projectPubspecYamlFile.writeAsStringSync(yamlEditor.toString());

    print("添加 font assets 节点数据成功！！！");
  }
}

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

flutter_rapid_development_maker 是一个 Flutter/Dart 开发阶段的代码生成工具包，与 [flutter_rapid_development_kit](https://github.com/hbolin/flutter_rapid_development_kit) 配套使用。它通过命令行脚本（`_makers/` 目录下的文件）驱动，自动生成项目模板、资源引用类和配置文件。

## 常用命令

```bash
# 运行测试
flutter test

# 运行单个测试文件
flutter test test/sp_maker_test.dart

# Dart 分析
dart analyze

# 获取依赖
flutter pub get
```

## 架构

### 核心分层

```
lib/src/
  ├── base/          # 基础工具：目录读取、YAML编辑
  ├── asset/         # 资源生成器：图片、字体、SP模型
  └── project/       # 项目脚手架生成
```

- **base/pubspec_editor.dart** — 使用 `yaml` + `yaml_edit` 操作 pubspec.yaml，支持添加/替换 dependencies、dev_dependencies、dependency_overrides、image assets、font assets 节点
- **base/read_directory_files.dart** — 递归读取目录结构，返回 `DirectoryUnderFiles` 列表；包含 `Directory`、`File`、`String` 的扩展方法

- **asset/image_asset_maker.dart** — 扫描图片目录，生成嵌套的静态资源引用类（如 `AppImageAsset`），同时更新 pubspec.yaml 的 flutter.assets 节点
- **asset/font_asset_maker.dart** — 扫描字体目录，生成字体族引用类，同时更新 pubspec.yaml 的 flutter.fonts 节点
- **asset/sp_maker.dart** — 基于 `SharedPreferencesUtil` 生成模型的存取工具类代码
- **asset/delete_ds_store_file.dart** — 递归删除 .DS_Store 文件

- **project/project_maker.dart** — 完整的项目脚手架生成：`flutter create` → git init → 注入依赖 → 生成 main.dart/application.dart/route_util.dart → 生成 SplashPage/RootPage 模板 → 创建资源目录和 makers 脚本 → 添加 linter 规则 → pub get

### _makers/ 目录（非库代码）

这是工具的入口脚本目录，不属于 `lib/`，不被打包发布：
- **frdm_maker.dart** — 自动扫描 `lib/src/` 并重新生成 `lib/flutter_rapid_development_maker.dart` 的 export 声明
- **project_maker.dart** — 调用 `ProjectMaker.makeProject()` 创建新项目的示例脚本

### 数据流

资源生成器（ImageAssetMaker / FontAssetMaker）的工作模式：扫描目录 → 删除 .DS_Store → 生成 Dart 资源类文件 → 更新目标项目的 pubspec.yaml。

## 关键依赖

- `yaml` + `yaml_edit` — YAML 解析与结构化编辑（保留注释和格式）
- `process_run` — 执行 shell 命令（flutter create、git、pub get）
- `path` — 跨平台路径操作（在 read_directory_files.dart 和 pubspec_editor.dart 中使用）
- `collection` — 排序工具（`sortedBy`）

## 开发约定

- SDK 最低要求：`^3.10.7`
- 库入口文件 `lib/flutter_rapid_development_maker.dart` 由 `_makers/frdm_maker.dart` 自动生成，不要手动编辑
- 新增 `lib/src/` 下的源文件后，需运行 `_makers/frdm_maker.dart` 重新生成 export 声明
- Lint 规则：使用 `flutter_lints`

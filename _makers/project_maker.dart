import 'package:flutter_rapid_development_maker/flutter_rapid_development_maker.dart';

Future<void> main() async {
  await ProjectMaker.makeProject(
    flutterPath: "/Volumes/exmac/env/FlutterSDK/flutter_macos_arm64_3.38.6-stable/bin/flutter",
    targetProjectDirectoryPath: "/Volumes/exmac/Downloads/11/example",
    packageName: "com.demo.example",
    needGit: true,
  );

  PubspecEditor.replaceYamlDependencies("/Volumes/exmac/development2/workspace2/flutter2/dy-app-v4/pubspec.yaml", "/Volumes/exmac/Downloads/11/example/pubspec.yaml");
  PubspecEditor.replaceYamlDevDependencies("/Volumes/exmac/development2/workspace2/flutter2/dy-app-v4/pubspec.yaml", "/Volumes/exmac/Downloads/11/example/pubspec.yaml");
  PubspecEditor.replaceYamlDependencyOverrides("/Volumes/exmac/development2/workspace2/flutter2/dy-app-v4/pubspec.yaml", "/Volumes/exmac/Downloads/11/example/pubspec.yaml");
}

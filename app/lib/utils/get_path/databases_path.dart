import 'dart:io';
import 'package:ai_assisted_reader/utils/platform_utils.dart';

import 'package:sqflite/sqflite.dart';

import 'get_base_path.dart';

Future<String> getAnxDataBasesPath() async {
  switch (AarPlatform.type) {
    case AarPlatformEnum.android:
    case AarPlatformEnum.ohos:
      final path = await getDatabasesPath();
      return path;
    case AarPlatformEnum.windows:
    case AarPlatformEnum.macos:
    case AarPlatformEnum.ios:
      final documentsPath = await getAnxDocumentsPath();
      return '$documentsPath${Platform.pathSeparator}databases';
  }
}

Future<Directory> getAnxDataBasesDir() async {
  return Directory(await getAnxDataBasesPath());
}

import 'dart:io';

import 'package:ai_assisted_reader/utils/get_path/get_base_path.dart';
import 'package:ai_assisted_reader/utils/platform_utils.dart';
import 'package:path_provider/path_provider.dart';

// Future<Directory> getAnxSharedPrefsDir() async {
//   switch(defaultTargetPlatform) {
//     case TargetPlatform.android:
//       // com.example.app/shared_prefs
//       final docPath = await getAnxDocumentsPath();
//       final sharedPrefsDirPath = '${docPath.split('/app_flutter')[0]}/shared_prefs';
//       return Directory(sharedPrefsDirPath);
//     case TargetPlatform.windows:
//       return Directory("${(await getApplicationSupportDirectory()).path}\\shared_preferences.json");
//     default:
//       throw Exception('Unsupported platform');
//   }
// }

String getSharedPrefsFileName() {
  switch (AarPlatform.type) {
    case AarPlatformEnum.android:
      return 'FlutterSharedPreferences.xml';
    case AarPlatformEnum.windows:
      return 'shared_preferences.json';
    case AarPlatformEnum.macos:
    case AarPlatformEnum.ios:
      return 'com.aiassisted.reader.plist';
    case AarPlatformEnum.ohos:
      return 'FlutterSharedPreferences';
  }
}

Future<File> getAnxShredPrefsFile() async {
  switch (AarPlatform.type) {
    case AarPlatformEnum.android:
      final docPath = await getAnxDocumentsPath();
      final sharedPrefsDirPath =
          '${docPath.split('/app_flutter')[0]}/shared_prefs';
      return File('$sharedPrefsDirPath/${getSharedPrefsFileName()}');

    case AarPlatformEnum.windows:
      return File(
          "${(await getApplicationSupportDirectory()).path}\\${getSharedPrefsFileName()}");
    case AarPlatformEnum.macos:
      final baseDir =
          '${(await getAnxDocumentsPath()).split('Documents')[0]}Library/Preferences';
      return File("$baseDir/${getSharedPrefsFileName()}");
    case AarPlatformEnum.ios:
      final baseDir =
          '${((await getApplicationDocumentsDirectory()).path).split('Documents')[0]}Library/Preferences';
      return File("$baseDir/${getSharedPrefsFileName()}");
    case AarPlatformEnum.ohos:
      final docPath = await getAnxDocumentsPath();
      final sharedPrefsDirPath = '${docPath.split('/base')[0]}/preferences';
      return File('$sharedPrefsDirPath/${getSharedPrefsFileName()}');
  }
}

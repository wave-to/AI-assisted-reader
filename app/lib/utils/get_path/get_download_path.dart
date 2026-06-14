import 'dart:io';
import 'package:ai_assisted_reader/utils/platform_utils.dart';

import 'package:path_provider/path_provider.dart' as path;
import 'package:permission_handler/permission_handler.dart';

// from localsend
Future<String> getDownloadPath() async {
  switch (AarPlatform.type) {
    case AarPlatformEnum.android:
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        await Permission.manageExternalStorage.request();
      }
      return '/storage/emulated/0/Download';
    case AarPlatformEnum.ios:
      return (await path.getApplicationDocumentsDirectory()).path;
    case AarPlatformEnum.macos:
    case AarPlatformEnum.windows:
    case AarPlatformEnum.ohos:
      var downloadDir = await path.getDownloadsDirectory();
      if (downloadDir == null) {
        if (AarPlatform.isWindows) {
          downloadDir =
              Directory('${Platform.environment['HOMEPATH']}/Downloads');
          if (!downloadDir.existsSync()) {
            downloadDir = Directory(Platform.environment['HOMEPATH']!);
          }
        } else {
          downloadDir = Directory('${Platform.environment['HOME']}/Downloads');
          if (!downloadDir.existsSync()) {
            downloadDir = Directory(Platform.environment['HOME']!);
          }
        }
      }
      return downloadDir.path.replaceAll('\\', '/');
  }
}

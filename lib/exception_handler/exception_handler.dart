import 'dart:io';

import 'package:hp_cli/common/utils/logger/log_utils.dart';

import 'cli_exception.dart';

class ExceptionHandler {
  void handle(dynamic e) {
    if (e is CliException) {
      LogService.error(e.message!);
      if (e.codeSample!.isNotEmpty) {
        LogService.info('Example', false, false);
        // ignore: avoid_print
        print(LogService.codeBold(e.codeSample!));
      }
    } else if (e is FileSystemException) {
      if (e.osError!.errorCode == 2) {
        LogService.error('File not found ${e.path}');
        return;
      } else if (e.osError!.errorCode == 13) {
        LogService.error('Access denied ${e.path}');
        return;
      }
      _logException(e.message);
    } else {
      _logException(e.toString());
    }
    if (!Platform.isWindows) exit(0);
  }

  static void _logException(String msg) {
    LogService.error('Unexpected  error $msg');
  }
}

import 'package:hp_cli/hp_cli.dart' as hp_cli;

void main(List<String> arguments) {
  var time = Stopwatch();
  time.start();
  print('Hello world: ${hp_cli.calculate()}!');

  // final command = GetCli(arguments).findCommand();
  //
  // if (arguments.contains('--debug')) {
  //   if (command.validate()) {
  //     await command.execute().then((value) => checkForUpdate());
  //   }
  // } else {
  //   try {
  //     if (command.validate()) {
  //       await command.execute().then((value) => checkForUpdate());
  //     }
  //   } on Exception catch (e) {
  //     ExceptionHandler().handle(e);
  //   }
  // }

  time.stop();
  // LogService.info('Time: ${time.elapsed.inMilliseconds} Milliseconds');
}

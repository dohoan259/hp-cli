import 'package:hp_cli/commands/command_list.dart';
import 'package:hp_cli/commands/impl/help/help.dart';
import 'package:hp_cli/commands/interface/command.dart';
import 'package:hp_cli/common/utils/logger/log_utils.dart';

class HpCli {
  final List<String> _arguments;

  HpCli(this._arguments) {
    _instance = this;
  }

  static HpCli? _instance;
  static HpCli? get to => _instance;

  static List<String> get arguments => to!._arguments;

  Command findCommand() => _findCommand(0, commands);

  Command _findCommand(int currentIndex, List<Command> commands) {
    try {
      final currentArg = arguments[currentIndex].split(':').first;

      var cmd = commands.firstWhere(
        (command) =>
            command.commandName == currentArg ||
            command.alias.contains(currentArg),
        orElse: () => ErrorCommand('command not found'),
      );
      if (cmd.children.isNotEmpty) {
        if (cmd is CommandParent) {
          cmd = _findCommand(++currentIndex, cmd.children);
        } else {
          var childrenCmd = _findCommand(++currentIndex, cmd.children);
          if (childrenCmd is! ErrorCommand) {
            cmd = childrenCmd;
          }
        }
      }
      return cmd;
    } on RangeError catch (_) {
      return HelpCommand();
    } on Exception catch (_) {
      rethrow;
    }
  }
}

class ErrorCommand extends Command {
  @override
  String get commandName => 'on error';
  String error;
  ErrorCommand(this.error);
  @override
  Future<void> execute() async {
    LogService.error(error);
    LogService.info('run `get help` to help', false, false);
  }

  @override
  String get hint => 'Print on erro';

  @override
  String get codeSample => '';

  @override
  int get maxParams => 0;

  @override
  bool validate() => true;
}

class NotFoundCommand extends Command {
  @override
  String get commandName => 'Not Found Command';

  @override
  Future<void> execute() async {
    //Command findCommand() => _findCommand(0, commands);
  }

  @override
  String get hint => 'Not Found Command';

  @override
  String get codeSample => '';

  @override
  int get maxParams => 0;

  @override
  bool validate() => true;
}

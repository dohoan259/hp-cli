import 'package:hp_cli/commands/impl/argument_mixin.dart';

abstract class Command with ArgsMixin {
  Command() {
    while (
        ((args.contains(commandName) || args.contains('$commandName:$name'))) &&
            args.isNotEmpty) {
      args.removeAt(0);
    }
    if (args.isNotEmpty && args.first == name) {
      args.removeAt(0);
    }
  }

  int get maxParams;

  String? get codeSample;
  String get commandName;

  List<String> get alias => [];

  List<String> get acceptedFlags => [];

  /// hint for command
  String? get hint;

  /// validate command line argument
  bool validate() {
    return true;
  }

  /// execute command
  Future<void> execute();

  /// children command
  List<Command> get children => [];
}

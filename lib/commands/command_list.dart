import 'package:hp_cli/commands/impl/create/page/page.dart';

import 'interface/command.dart';

final List<Command> commands = [
  CommandParent(
    'create',
    [
      CreatePageCommand(),
    ],
    ['-c'],
  ),
];

class CommandParent extends Command {
  final String _name;
  final List<String> _alias;
  final List<Command> _children;
  CommandParent(this._name, this._children, [this._alias = const []]);

  @override
  String get commandName => _name;
  @override
  List<Command> get children => _children;
  @override
  List<String> get alias => _alias;

  @override
  Future<void> execute() async {}

  @override
  String get hint => '';

  @override
  bool validate() => true;

  @override
  String get codeSample => '';

  @override
  int get maxParams => 0;
}

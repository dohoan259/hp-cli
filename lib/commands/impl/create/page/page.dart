import 'dart:io';

import 'package:cli_dialog/cli_dialog.dart';
import 'package:hp_cli/commands/interface/command.dart';
import 'package:hp_cli/core/generator.dart';
import 'package:hp_cli/core/structure.dart';
import 'package:recase/recase.dart';

class CreatePageCommand extends Command {
  @override
  // TODO: implement codeSample
  String? get codeSample => throw UnimplementedError();

  @override
  String get commandName => 'page';

  @override
  List<String> get alias => ['module', '-p', 'm'];

  @override
  Future<void> execute() async {
    var isProject = false;
    if (HpCli.arguments[0] == 'create' || HpCli.arguments[0] == 'c') {
      isProject = HpCli.arguments[1].split(':').first == 'project';
    }
    var name = this.name;
    if (name.isNotEmpty || isProject) {
      name = 'home';
    }
    checkForAlreadyExists(name);
  }

  void checkForAlreadyExists(String? name) {
    var _fileModel =
        Structure.model(name, 'page', true, on: onCommand, folderName: name);
    var pathSplit = Structure.safeSplitPath(_fileModel.path!);

    pathSplit.removeLast();
    var path = pathSplit.join('/');
    path = Structure.replaceAsExpected(path: path);
    if (Directory(path).existsSync()) {
      final menu = Menu(
        [
          LocaleKeys.options_yes.tr,
          LocaleKeys.options_no.tr,
          LocaleKeys.options_rename.tr,
        ],
        title:
            Translation(LocaleKeys.ask_existing_page.trArgs([name])).toString(),
      );
      final result = menu.choose();
      if (result.index == 0) {
        _writeFiles(path, name!, overwrite: true);
      } else if (result.index == 2) {
        final dialog = CLI_Dialog();
        dialog.addQuestion(LocaleKeys.ask_new_page_name.tr, 'name');
        name = dialog.ask()['name'] as String?;

        checkForAlreadyExists(name!.trim().snakeCase);
      }
    } else {
      Directory(path).createSync(recursive: true);
      _writeFiles(path, name!, overwrite: false);
    }
  }

  void _writeFiles(String path, String name, {bool overwrite = false}) {
    var isServer = PubspecUtils.isServerProject;
    var extraFolder = PubspecUtils.extraFolder ?? true;
    var controllerFile = handleFileCreate(
      name,
      'controller',
      path,
      extraFolder,
      ControllerSample(
        '',
        name,
        isServer,
        overwrite: overwrite,
      ),
      'controllers',
    );
    var controllerDir = Structure.pathToDirImport(controllerFile.path);
    var viewFile = handleFileCreate(
      name,
      'view',
      path,
      extraFolder,
      GetViewSample(
        '',
        '${name.pascalCase}View',
        '${name.pascalCase}Controller',
        controllerDir,
        isServer,
        overwrite: overwrite,
      ),
      'views',
    );
    var bindingFile = handleFileCreate(
      name,
      'binding',
      path,
      extraFolder,
      BindingSample(
        '',
        name,
        '${name.pascalCase}Binding',
        controllerDir,
        isServer,
        overwrite: overwrite,
      ),
      'bindings',
    );

    addRoute(
      name,
      Structure.pathToDirImport(bindingFile.path),
      Structure.pathToDirImport(viewFile.path),
    );
    LogService.success(LocaleKeys.sucess_page_create.trArgs([name.pascalCase]));
  }

  @override
  String? get hint => 'Create page';

  @override
  int get maxParams => 0;
}

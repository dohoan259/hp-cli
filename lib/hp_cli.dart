import 'dart:io';

void main() async {
  print('Hello');

  final results = await Process.run('dir', []);
  print(results.stdout);
}

int calculate() {
  return 6 * 7;
}

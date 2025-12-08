import 'dart:io';

final imagesDir = Directory('assets/images');
final outFile = File('lib/core/utils/assets_names.dart');

String makeIdentifier(String name) {
  // remove extension, replace non-alphanum with underscore, ensure starts with letter/_
  final base = name.replaceAll(RegExp(r'\.[^.]+$'), '');
  var id = base.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_');
  if (RegExp(r'^[0-9]').hasMatch(id)) id = '_$id';
  return id.toLowerCase();
}

void main() {
  if (!imagesDir.existsSync()) {
    stderr.writeln('assets/images folder not found.');
    exit(2);
  }

  final files = imagesDir.listSync().whereType<File>().toList();
  final buffer = StringBuffer();
  buffer.writeln('// Generated file. Do not edit by hand.');
  buffer.writeln('// filepath: lib/assets.dart');
  buffer.writeln();
  buffer.writeln('class Assets {');
  buffer.writeln('  Assets._();');
  buffer.writeln();
  buffer.writeln("  static const String imagesPath = 'assets/images';");
  buffer.writeln();

  for (final f in files) {
    final name = f.uri.pathSegments.last;
    final id = makeIdentifier(name);
    buffer.writeln("  static const String $id = 'assets/images/$name';");
  }

  buffer.writeln('}');
  outFile.writeAsStringSync(buffer.toString());
  stdout.writeln('Wrote ${outFile.path} with ${files.length} images.');
}
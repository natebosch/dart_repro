import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

void main() {
  final library = Library((b) => b);
  final emitter = DartEmitter(Allocator.simplePrefixing());
  final code = library.accept(emitter);
  print(DartFormatter().format('$code'));
}

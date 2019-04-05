abstract class Foo {
  int get foo;
}

class Bar implements Foo {
  static int _foo = 0;
  final foo = _foo++; // Error here.
}

import 'foo.dart' as i0;

import 'package:dart_repro/foo.dart' as i1;

void main() {
  print(i0.C() is i1.C);
}

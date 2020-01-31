@JS()
library js_interop;

import 'package:js/js.dart';

@JS('console.log')
external void log(Object o);

void main() {
  log('foo');
}

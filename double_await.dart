Future<Object> something() async {
  return f;
}

var f = Future<dynamic>.value(Future<int>.value(1));

void main() async {
  var f = something();
  print('have f: ${f.runtimeType}');
  var a = await f;
  print('have first: ${a.runtimeType}');
  var b = await a;
  print('have second: ${b.runtimeType}');
  print(a == b);
  (a as Future).then((b) {
    print('have second from .then: ${b.runtimeType}');
  });
}

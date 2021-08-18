void main() {
  var h = Uri.parse('file://a/b');
  var b = Uri.parse('file:///a/b');
  print(h == b);
  print(h.isAbsolute);
  print(b.isAbsolute);
  print(h.path);
  print(b.path);
  var a = Uri.parse('/a/b');
  print(h);
  print(h.scheme);
  print(h.hasScheme);
  print(h.scheme == '');
  print(h.isAbsolute);
  // print(a);
  // print(a.isAbsolute);
  // print(h.resolveUri(a));
  // print(h.resolveUri(a).isAbsolute);
}

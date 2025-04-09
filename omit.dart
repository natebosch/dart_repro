void main() async {
  final String s1 = await someGeneric(['']); // omit_local_variable_types
  print(typeOf(s1)); // String
  // Removing the annotation results in a behavior change:
  final s2 = await someGeneric(['']);
  print(typeOf(s2)); // dynamic
}

// Second type argument means inference won't fill in `T` based on argument
// value.
Future<T> someGeneric<T, S extends List<T>>(S v) async => v.first;

Type typeOf<T>(T arg) => T;

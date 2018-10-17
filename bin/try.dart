void main() async {
  print('before');
  printAsync();
  print('after');
}

void printAsync() async {
  print('running');
}

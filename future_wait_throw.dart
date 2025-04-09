void main() async {
  await Future.wait([
    Future.delayed(const Duration(seconds: 2), () {
      print('Slower succeeding');
      return 'hello';
    }),
    Future.delayed(const Duration(seconds: 1), () {
      print('Faster failing');
      throw 'sad';
    })
  ], cleanUp: (v) {
    print('Cleaning up: $v');
  });
}

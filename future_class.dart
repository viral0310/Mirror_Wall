Future getData() {
  Duration myDuration = Duration(seconds: 2);

  Future m = Future.delayed(myDuration, () => "2. Client are arrived...");

  return m;
}

void main() async {
  print("1.Business is Start...");

  String res = await getData();

/*res.then((value) {
    print(value);
  }).catchError((e) {
    print('Error : $e ');
  }).whenComplete(() {
    print('always Executes....');
  });*/
  print(res);
  print("3.Business Closed...");
}

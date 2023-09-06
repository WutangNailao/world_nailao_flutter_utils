import 'package:flutter/cupertino.dart';

void main(){runApp(const Myapp());}
class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: CupertinoPageScaffold(
        child: Center(
          child: Text('Hello, world!'),
        ),
      ),
    );
  }
}
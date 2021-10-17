import 'package:flutter/material.dart';

class DymaLoader extends StatelessWidget {
  const DymaLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}

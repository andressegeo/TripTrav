import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Il faut utiliser un Scafold, car la route va carrement
    // remplacer la page précédente
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text("Oops, Not Found"),
      ),
    );
  }
}

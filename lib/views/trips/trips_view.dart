import 'package:flutter/material.dart';

class TripsView extends StatefulWidget {
  static const String routeName = "/trips";
  @override
  _TripsViewState createState() => _TripsViewState();
}

class _TripsViewState extends State<TripsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes Voyages"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text("trips"),
      ),
    );
  }
}

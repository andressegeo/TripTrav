import 'package:flutter/material.dart';
import 'package:project_dyma_end/views/trips/widgets/trip_list.dart';
import '../../models/trip_model.dart';

class TripsView extends StatefulWidget {
  final List<Trip> trips;
  static const String routeName = "/trips";

  TripsView({this.trips});
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
      body: TripList(trips: widget.trips),
    );
  }
}

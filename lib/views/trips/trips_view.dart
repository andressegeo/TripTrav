import 'package:flutter/material.dart';
import 'package:project_dyma_end/views/trips/widgets/trip_list.dart';
import 'package:project_dyma_end/widgets/dyma_drawer.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mes Voyages"),
          bottom: const TabBar(
            tabs: [
              const Tab(
                text: "Passés",
                icon: Icon(Icons.directions_car),
              ),
              const Tab(
                text: "A venir",
                icon: Icon(Icons.directions_transit),
              ),
            ],
          ),
        ),
        drawer: const DymaDrawer(),
        body: TabBarView(
          children: [
            TripList(
              trips: widget.trips
                  .where(
                    (trip) => DateTime.now().isAfter(trip.date),
                  )
                  .toList(),
            ),
            TripList(
              trips: widget.trips
                  .where(
                    (trip) => DateTime.now().isBefore(trip.date),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import '../../providers/trip_provider.dart';
import '../../views/trips/widgets/trip_list.dart';
import '../../widgets/dyma_drawer.dart';
import '../../models/trip_model.dart';

class TripsView extends StatelessWidget {
  static const String routeName = "/trips";

  @override
  Widget build(BuildContext context) {
    List<Trip> trips = Provider.of<TripProvider>(context).trips;
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
              trips: trips
                  .where(
                    (trip) => DateTime.now().isAfter(trip.date),
                  )
                  .toList(),
            ),
            TripList(
              trips: trips
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

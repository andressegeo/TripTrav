import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import '../../providers/trip_provider.dart';
import '../../providers/trip_provider.dart';
import '../../views/trips/widgets/trip_list.dart';
import '../../widgets/dyma_drawer.dart';
import '../../models/trip_model.dart';
import '../../widgets/dyma_loader.dart';

class TripsView extends StatelessWidget {
  static const String routeName = "/trips";

  @override
  Widget build(BuildContext context) {
    TripProvider tripProvider = Provider.of<TripProvider>(context);
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
        body: tripProvider.isLoading == false
            ? tripProvider.trips.length > 0
                ? TabBarView(
                    children: [
                      TripList(
                        trips: tripProvider.trips
                            .where(
                              (trip) => DateTime.now().isAfter(trip.date),
                            )
                            .toList(),
                      ),
                      TripList(
                        trips: tripProvider.trips
                            .where(
                              (trip) => DateTime.now().isBefore(trip.date),
                            )
                            .toList(),
                      ),
                    ],
                  )
                : Container(
                    alignment: Alignment.center,
                    child: Text("Aucun voyage pour le moment..."),
                  )
            : DymaLoader(),
      ),
    );
  }
}

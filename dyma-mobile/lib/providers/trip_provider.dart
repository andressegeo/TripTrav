import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:project_dyma_end/models/activity_model.dart';
import '../models/trip_model.dart';

class TripProvider with ChangeNotifier {
  final List<Trip> _trips = [];

  UnmodifiableListView<Trip> get trips {
    return UnmodifiableListView(_trips);
  }

  void addTrip(Trip trip) {
    _trips.add(trip);
    notifyListeners();
  }

  Trip getTripById(String tripId) =>
      trips.firstWhere((trip) => trip.id == tripId);

  void setActivityToDone(Activity activity) {
    activity.status = ActivityStatus.done;
    notifyListeners();
  }
}

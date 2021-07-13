import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:project_dyma_end/models/activity_model.dart';
import '../models/trip_model.dart';

import 'package:http/http.dart' as http;
import "dart:convert";

class TripProvider with ChangeNotifier {
  final String host = "http://localhost:5000";
  List<Trip> _trips = [];

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

  Future<void> fetchData() async {
    try {
      http.Response resp = await http.get(
        Uri.parse("$host/dyma-api/trips/"),
      );
      if (resp.statusCode == 200) {
        _trips = (json.decode(resp.body) as List)
            .map(
              (tripJson) => Trip.fromJson(tripJson),
            )
            .toList();
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}

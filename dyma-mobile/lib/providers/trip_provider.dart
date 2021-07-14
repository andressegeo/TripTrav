import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_dyma_end/models/activity_model.dart';
import '../models/trip_model.dart';

import 'package:http/http.dart' as http;
import "dart:convert";

class TripProvider with ChangeNotifier {
  final String host = "http://localhost:5000";
  bool isLoading = false;
  List<Trip> _trips = [];

  UnmodifiableListView<Trip> get trips {
    return UnmodifiableListView(_trips);
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      http.Response resp = await http.get(
        Uri.parse("$host/dyma-api/trips/"),
      );
      if (resp.statusCode == 200) {
        print("status 200");
        _trips = (json.decode(resp.body) as List)
            .map(
              (tripJson) => Trip.fromJson(tripJson),
            )
            .toList();
        isLoading = false;
        notifyListeners();
      } else if (resp.statusCode == 204) {
        print("trip status");
        print(resp.statusCode);
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("errorTrip fetch");
      isLoading = false;
      rethrow;
    }
  }

  Future<void> addTrip(Trip trip) async {
    try {
      http.Response resp = await http.post(
        Uri.parse(
          "$host/dyma-api/trips/",
        ),
        body: json.encode(
          trip.toJson(),
        ),
        headers: {"Content-type": "application/json"},
      );

      if (resp.statusCode == 201 || resp.statusCode == 200) {
        _trips.add(
          Trip.fromJson(
            json.decode(resp.body),
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      print("addTrip error");
      print(e);
      rethrow;
    }
  }

  Future<void> updateTrip(Trip trip, String activityId) async {
    try {
      Activity activity =
          trip.activities.firstWhere((activity) => activity.id == activityId);

      activity.status = ActivityStatus.done;

      http.Response resp = await http.put(
        Uri.parse(
          "$host/dyma-api/trips/${trip.id}",
        ),
        body: json.encode(
          trip.toJson(),
        ),
        headers: {"Content-type": "application/json"},
      );

      if (resp.statusCode != 200) {
        activity.status = ActivityStatus.ongoing;
        throw HttpException("Error put trip");
      }
      notifyListeners();
    } catch (e) {
      print("error updateTrip");
      rethrow;
    }
  }

  Trip getTripById(String tripId) =>
      trips.firstWhere((trip) => trip.id == tripId);
}

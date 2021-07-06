import 'dart:collection';

import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../datas/data.dart' as data;

class TripProvider with ChangeNotifier {
  final List<Trip> _trips = data.trips;

  UnmodifiableListView<Trip> get trips {
    return UnmodifiableListView(_trips);
  }
}

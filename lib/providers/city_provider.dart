import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/city_model.dart';
import '../datas/data.dart' as data;

class CityProvider with ChangeNotifier {
  final List<City> _cities = data.cities;
  // UnmodifiableListView coe son nom l'indique, va bloquer toute tentative
  // de modification de la list de city
  UnmodifiableListView<City> get cities {
    return UnmodifiableListView(_cities);
  }

  City getCityByName(String cityName) =>
      cities.firstWhere((city) => city.name == cityName);
}

import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/city_model.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

import '../models/city_model.dart';

class CityProvider with ChangeNotifier {
  final String host = "http://localhost:5000";
  List<City> _cities = [];
  // UnmodifiableListView coe son nom l'indique, va bloquer toute tentative
  // de modification de la list de city
  UnmodifiableListView<City> get cities {
    return UnmodifiableListView(_cities);
  }

  City getCityByName(String cityName) =>
      cities.firstWhere((city) => city.name == cityName);

  Future<void> fetchData() async {
    try {
      http.Response resp = await http.get(
        // Uri.parse("http://10.0.2.2:5000/dyma-api/cities/"),
        Uri.parse("$host/dyma-api/cities/"),
      );
      if (resp.statusCode == 200) {
        _cities = (json.decode(resp.body) as List)
            .map(
              (cityJson) => City.fromJson(cityJson),
            )
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print("error");
      print(e);
    }
  }
}

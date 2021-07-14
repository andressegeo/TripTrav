import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/city_model.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

import '../models/city_model.dart';

class CityProvider with ChangeNotifier {
  final String host = "http://localhost:5000";
  bool isLoading = false;
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
      isLoading = true;
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
        isLoading = false;
        notifyListeners();
      } else if (resp.statusCode == 204) {
        print("city status");
        print(resp.statusCode);
      }
    } catch (e) {
      print("error");
      isLoading = false;
      print(e);
    }
  }
}

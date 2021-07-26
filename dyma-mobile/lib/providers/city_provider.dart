import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_dyma_end/models/activity_model.dart';
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

  City getCityByName(String cityName) {
    return cities.firstWhere((city) => city.name == cityName);
  }

  UnmodifiableListView<City> getFilteredCities(String filter) =>
      UnmodifiableListView(
        _cities
            .where(
              (city) => city.name.toLowerCase().startsWith(
                    filter.toLowerCase(),
                  ),
            )
            .toList(),
      );

  Future<void> addActivityToCity(Activity newActivity) async {
    try {
      String cityId = getCityByName(newActivity.city).id;
      http.Response resp = await http.put(
        Uri.parse(
          "$host/dyma-api/cities/$cityId",
        ),
        body: json.encode(
          newActivity.toJson(),
        ),
        headers: {"Content-type": "application/json"},
      );
      if (resp.statusCode == 200) {
        // Le serveur retourne la nvelle ville en cas de succès
        // Il faut remplacer l'ancienne ville par la nvelle en la réassignant
        int index = cities.indexWhere((city) =>
            city.id == cityId); // retourne l'index du 1er elmt qui match
        _cities[index] = City.fromJson(
          json.decode(resp.body),
        );
        print("put well");
      } else {
        throw HttpException("Error put activities on city");
      }
      notifyListeners();
    } catch (e) {
      print("error post");
      print(e);
      rethrow;
    }
  }

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

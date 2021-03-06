import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_dyma_end/models/activity_model.dart';
import '../models/city_model.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import "package:path/path.dart";
import "package:http_parser/http_parser.dart";

class CityProvider with ChangeNotifier {
  // final String host = "http://localhost:5000";
  // final String host = "http://dymatrip-dev.appspot.com/";
  final String host = "https://triptrav-api-e22cijqu4q-ew.a.run.app/";

  bool isLoading = false;
  List<City> _cities = [];
  // UnmodifiableListView coe son nom l'indique, va bloquer toute tentative
  // de modification de la list de city
  UnmodifiableListView<City> get cities {
    return UnmodifiableListView(_cities);
  }

  City getCityByName(String? cityName) {
    return cities.firstWhere((city) => city.name == cityName);
  }

  UnmodifiableListView<City> getFilteredCities(String filter) =>
      UnmodifiableListView(
        _cities
            .where(
              (city) => city.name!.toLowerCase().startsWith(
                    filter.toLowerCase(),
                  ),
            )
            .toList(),
      );

  Future<void> addActivityToCity(Activity newActivity) async {
    try {
      String? cityId = getCityByName(newActivity.city).id;
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

  Future<dynamic> verifyIfActivityNameIsUnique(
    String cityName,
    String activityName,
  ) async {
    try {
      City city = getCityByName(cityName);
      http.Response resp = await http.get(
        // TO make works in android simulator, use this uri
        // Uri.parse("http://10.0.2.2:5000/dyma-api/cities/"),
        Uri.parse(
            "$host/dyma-api/cities/${city.id}/activities/verify/$activityName"),
      );
      print("resp: ${resp.statusCode}");
      if (resp.statusCode != 200) {
        var bodyJson = json.decode(resp.body);
        return bodyJson;
      }
    } catch (e) {
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

  Future<String> uploadImage(File pickedImage) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$host/dyma-api/cities/activity/image"),
      );
      print("pickedImage: $pickedImage");
      request.files.add(
        http.MultipartFile.fromBytes(
          "activity_image",
          pickedImage.readAsBytesSync(),
          filename: basename(pickedImage.path),
          contentType: MediaType("multipart", "form-data"),
          // la diff entre les 2 c'est qu'une fois dans le bucket,
          // le clique sur le jpeg est lisible par le navigateur contrairement
          // au multipart qui va etre download dans la machine avant d'être consulté
          // contentType: MediaType("image", "jpeg"),
        ),
      );

      var resp = await request.send();
      print("status: ${resp.statusCode}");
      // Response is a stream, il faut attendre l'intégralité du retour avant de continuer
      if (resp.statusCode == 201) {
        // pas le meme type de retour qu'un HttpResponse
        // Il faut le streamer pour le lire
        var responseData = await resp.stream.toBytes();
        var respStringDecoded = json.decode(String.fromCharCodes(responseData));
        print(respStringDecoded["response"]["url"]);
        final String url = respStringDecoded["response"]["url"];
        return url;
      } else {
        print("error while saving image from server");
        print("status: ${resp.statusCode}");
        throw 'error';
      }
    } catch (e) {
      rethrow;
    }
  }
}

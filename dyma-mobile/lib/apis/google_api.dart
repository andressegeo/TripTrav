import 'package:project_dyma_end/models/activity_model.dart';
import 'package:project_dyma_end/models/place_model.dart';
import 'package:http/http.dart' as http;
import "dart:convert"; // Pour exploiter la méthode json.decode

const GOOGLE_KEY_API = "AIzaSyCgAI4suYnxmP1br58skW6ZnlYDarq_eUM";

// Une  Uri permet d'encoder notre url
Uri _queryAutoCompleteBuilder(String query) {
  return Uri.parse(
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?&key=$GOOGLE_KEY_API&input=$query");
}

Uri _queryPlaceDetailsBuilder(String placeId) {
  return Uri.parse(
      "https://maps.googleapis.com/maps/api/place/details/json?fields=formatted_address%2Cgeometry&place_id=$placeId&key=$GOOGLE_KEY_API");
}

Future<List<Place>> getAutoCompleteSuggestions(String query) async {
  // Toujours faire un try catch pour call asynchrone
  try {
    var response = await http.get(
      _queryAutoCompleteBuilder(query),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      // Là on a un objet avec une key "predictions"
      // body["predictions"] c'est une liste, ici on la recupère exlpicitement en tant que liste
      // notre fonction doit retourner une ListPlace, du coup il faut ittérer dessus pour
      // convertir chaque elemt en Place puis reconvertir l'ensemble en List avant de la renvoyer
      // à sa fonction appellante
      var resp = (body["predictions"] as List)
          .map(
            (suggestion) => Place(
              description: suggestion["description"],
              placeId: suggestion["place_id"],
            ),
          )
          .toList();
      return resp;
    } else {
      print("no to return");
      return [];
    }
    // return response;
  } catch (e) {
    print("errorgetAutoCompleteSuggestions: $e");
    rethrow;
  }
}

Future<LocationActivity> getPlaceDetailsApi(String placeId) async {
  try {
    var response = await http.get(
      _queryPlaceDetailsBuilder(placeId),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body)["result"];
      // var resp = (body["result"] as )
      return LocationActivity(
        address: body["formatted_address"],
        latitude: body["geometry"]["location"]["lat"],
        longitude: body["geometry"]["location"]["lng"],
      );
    } else {
      // S'il n'arrive pas à recupérer une detail Places avec le placeId
      // si statusCode != 200, throw une erreur
      throw "erreur errorgetDetails";
      // return LocationActivity(address: "", latitude: null, longitude: null);
    }
  } catch (e) {
    print("errorgetDetails: $e");
    rethrow;
  }
}

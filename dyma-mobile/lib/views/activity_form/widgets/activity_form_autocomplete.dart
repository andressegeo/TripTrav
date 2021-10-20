import 'dart:async'; // aide au debounce ou le timer pour attendre une sec le temps que le user saisisse la recherche
import 'package:flutter/material.dart';
import 'package:project_dyma_end/apis/google_api.dart';
import 'package:project_dyma_end/models/activity_model.dart';
import 'package:project_dyma_end/models/place_model.dart';

Future<LocationActivity?> showInputAutoComplete(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => InputAddress(),
  );
}

class InputAddress extends StatefulWidget {
  const InputAddress({Key? key}) : super(key: key);

  @override
  _InputAdressState createState() => _InputAdressState();
}

class _InputAdressState extends State<InputAddress> {
  List<Place> _places = [];
  // Le debounce via Timer va aider à patienter 1 sec avant de faire l'appel
  // l'appel api pour pas qu'à chaque lettre que le user tape, il fasse systematiquement un appel api
  // Ca évite de spammer les api
  Timer? _debounce;
  // On va faire un call asynchrone sur l'api de google
  Future<void> _searchAdress(String value) async {
    try {
      if (_debounce?.isActive == true) _debounce?.cancel();
      _debounce = Timer(Duration(seconds: 1), () async {
        if (value.isNotEmpty) {
          print("value to search: $value");
          _places = await getAutoCompleteSuggestions(value);
          // le setState ne peut être asynchrone, il est tjrs synchrone
          // Donc après avoir retrieve les places, on set le state
          setState(() {});
        }
      });
    } catch (e) {
      print("error_searchAdress: $e");
      rethrow;
    }
  }

  Future<void> getPlaceDetails(String placeId) async {
    try {
      print(placeId);
      LocationActivity? location = await getPlaceDetailsApi(placeId);
      if (location is LocationActivity) {
        // Ici on quitte la pop up en recupérant la location
        Navigator.pop(context, location);
      } else {
        Navigator.pop(context, null);
      }
    } catch (e) {
      print("errorgetPlaceDetails: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scafold pour qu'il prenne tout l'espace
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Rechercher",
                  prefixIcon: Icon(Icons.search),
                ),
                // Methode callback pour recupérer la valeur actuelle de notre TextField
                onChanged: _searchAdress,
              ),
              Positioned(
                top: 5,
                right: 3,
                child: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => Navigator.pop(context, null),
                ),
              ),
            ],
          ),
          // Sans le expanded, le listViewer va essayer de prendre tout  l'espace disponible
          // mais sauf qu'il ne sait pas quel space est dispo du coup il crache
          Expanded(
            child: ListView.builder(
              itemCount: _places.length,
              itemBuilder: (_, i) {
                var place = _places[i];
                return ListTile(
                  leading: Icon(
                    Icons.place,
                  ),
                  title: Text(place.description),
                  onTap: () => getPlaceDetails(place.placeId),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

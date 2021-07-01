import 'package:flutter/material.dart';
import 'models/activity_model.dart';
import 'views/trip/trip_view.dart';
import 'models/trip_model.dart';
import 'models/city_model.dart';
import 'views/trips/trips_view.dart';
import 'views/404/not_found.dart';
import 'views/home/home_view.dart';
import 'views/city/city_view.dart';
import 'datas/data.dart' as data;

main() {
  runApp(DymaTrip());
}

class DymaTrip extends StatefulWidget {
  final List<City> cities = data.cities;
  @override
  _DymaTripState createState() => _DymaTripState();
}

class _DymaTripState extends State<DymaTrip> {
  List<Trip> trips = [
    Trip(
      activities: [
        Activity(
          image: "assets/images/activities/louvre.jpeg",
          name: "Louvre",
          id: "a1",
          city: "Paris",
          price: 12.00,
        ),
        Activity(
          image: "assets/images/activities/chaumont.jpeg",
          name: "Chaumont",
          id: "a2",
          city: "Paris",
          price: 0.00,
        ),
        Activity(
          image: "assets/images/activities/dame.jpeg",
          name: "Notre Dame",
          id: "a3",
          city: "Paris",
          price: 0.00,
        ),
      ],
      city: "Paris",
      date: DateTime.now().add(
        Duration(days: 1),
      ),
    ),
    Trip(
      activities: [],
      city: "Lyon",
      date: DateTime.now().add(
        Duration(days: 2),
      ),
    ),
    Trip(
      activities: [],
      city: "Nice",
      date: DateTime.now().subtract(
        Duration(days: 1),
      ),
    )
  ];

  void addTrip(Trip trip) {
    setState(() {
      trips.add(trip);
    });
  }

  void removeAdd(Trip trip) {
    setState(() {
      trips.remove(trip);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // primarySwatch: Colors.red,
        // accentColor: Colors.green,
        appBarTheme: AppBarTheme(
          // definition d'un theme pour le texte dans nos AppBar
          // en copiant les memes valeurs d'autres features mais en modifiant juste le fontSize du texte
          textTheme: ThemeData.light().textTheme.copyWith(
                // use headline6 instead title who's deprecated
                headline6: TextStyle(fontSize: 30),
              ),
        ),
        // definition d'un textTheme generique(pas qu'à l'AppBAr)
        // Pour l'utiliser dans un composant, exploiter l'inheritedWidget qu'est theme
        // dans le widget enfant puis appeler la propriété headline6
        // Le texte de l'enfant aura donc la couleur Bleu

        // textTheme: ThemeData.light().textTheme.copyWith(
        //       headline6: TextStyle(
        //         color: Colors.blue,
        //         // fontSize: 30,
        //       ),
        //     ),
      ),
      debugShowCheckedModeBanner: false,
      // home: HomeView(),
      // initialRoute: "/city",
      // initialRoute permet de faire abstraction
      //  de la home ou de la route:"/" Si existe, elle sera la première route à checker
      routes: {
        // On ne peut à la fois utiliser la route / et la propriété ^^ home, il faut choisir
        HomeView.routeName: (context) => HomeView(
              cities: widget.cities,
            ),
        // "/city": (context) => Data(child: CityView()),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case CityView.routeName:
            {
              return MaterialPageRoute(
                builder: (context) {
                  final City city = settings.arguments;
                  return CityView(
                    city: city,
                    addTrip: addTrip,
                  );
                },
              );
            }
          case TripsView.routeName:
            {
              return MaterialPageRoute(
                builder: (context) {
                  return TripsView(trips: trips);
                },
              );
            }
          case TripView.routeName:
            {
              return MaterialPageRoute(
                builder: (context) {
                  String tripId =
                      (settings.arguments as Map<String, String>)["tripId"];
                  String cityName =
                      (settings.arguments as Map<String, String>)["cityName"];
                  return TripView(
                    trip: trips.firstWhere(
                      (trip) => trip.id == tripId,
                    ),
                    city: widget.cities.firstWhere(
                      (city) => city.name == cityName,
                    ),
                  );
                },
              );
            }
        }
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return NotFound();
          },
        );
      },
    );
  }
}

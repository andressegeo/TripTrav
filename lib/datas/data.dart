import '../models/trip_model.dart';

import '../models/city_model.dart';

import '../models/activity_model.dart';

List<City> cities = [
  City(
    name: "Paris",
    image: "assets/images/paris.jpeg",
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
      Activity(
        image: "assets/images/activities/defense.jpeg",
        name: "La Defense",
        id: "a4",
        city: "Paris",
        price: 0.00,
      ),
      Activity(
        image: "assets/images/activities/effeil.jpeg",
        name: "Tour Effeil",
        id: "a5",
        city: "Paris",
        price: 15.00,
      ),
      Activity(
        image: "assets/images/activities/luxembourg.jpeg",
        name: "Jardin Luxembourg",
        id: "a6",
        city: "Paris",
        price: 0.00,
      ),
      Activity(
        image: "assets/images/activities/mitterand.jpeg",
        name: "Bibliotheque Mitterand",
        id: "a7",
        city: "Paris",
        price: 0.00,
      ),
      Activity(
        image: "assets/images/activities/montmarte.jpeg",
        name: "Montmarte",
        id: "a8",
        city: "Paris",
        price: 0.00,
      ),
      Activity(
        image: "assets/images/activities/catacombes.jpeg",
        name: "Catacombes",
        id: "a9",
        city: "Paris",
        price: 0.00,
      )
    ],
  ),
  City(
    name: "Lyon",
    image: "assets/images/lyon.jpeg",
    activities: [
      Activity(
        image: "assets/images/activities/lyon_opera.jpeg",
        name: "Opera",
        id: "l1",
        city: "Lyon",
        price: 100.00,
      ),
      Activity(
        image: "assets/images/activities/lyon_bellecour.jpeg",
        name: "Place Bellecour",
        id: "l2",
        city: "Lyon",
        price: 0.00,
      ),
      Activity(
        image: "assets/images/activities/lyon_basilique.jpeg",
        name: "Basilique St-Pierre",
        id: "l3",
        city: "Lyon",
        price: 10.00,
      ),
      Activity(
        image: "assets/images/activities/lyon_mairie.jpeg",
        name: "Mairie",
        id: "l4",
        city: "Lyon",
        price: 0.00,
      ),
    ],
  ),
  City(
    name: "Nice",
    image: "assets/images/nice.jpeg",
    activities: [
      Activity(
        image: "assets/images/activities/nice_orthodox.jpeg",
        name: "Opera",
        id: "n1",
        city: "Nice",
        price: 5.00,
      ),
      Activity(
        image: "assets/images/activities/nice_riviera.jpeg",
        name: "Riviera",
        id: "n2",
        city: "Nice",
        price: 0.00,
      ),
      Activity(
        image: "assets/images/activities/nice_promenade.jpeg",
        name: "Promenade des Anglais",
        id: "n3",
        city: "Nice",
        price: 0.00,
      ),
      Activity(
        image: "assets/images/activities/nice_opera.jpeg",
        name: "Opera",
        id: "n4",
        city: "Nice",
        price: 0.00,
      ),
    ],
  ),
];

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
        status: ActivityStatus.done,
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

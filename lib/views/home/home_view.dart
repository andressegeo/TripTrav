import 'package:flutter/material.dart';
import '../../models/city_model.dart';
import 'widgets/city_card.dart';

class HomeView extends StatefulWidget {
  static String routeName = "/";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeView> {
  List cities = [
    City(name: "Paris", image: "assets/images/paris.jpeg"),
    City(name: "Lyon", image: "assets/images/lyon.jpeg"),
    City(name: "Nice", image: "assets/images/nice.jpeg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: Text("DymaTrip"),
        actions: [Icon(Icons.more_vert)],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...cities.map(
              (city) => CityCard(
                city: city,
              ),
            )
          ],
        ),
      ),
    );
  }
}

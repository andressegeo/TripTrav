import 'package:flutter/material.dart';
import '../../widgets/dyma_drawer.dart';
import '../../widgets/ask_modal.dart';
import '../../models/city_model.dart';
import 'widgets/city_card.dart';

class HomeView extends StatefulWidget {
  static const String routeName = "/";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeView> {
  List cities = [
    City(name: "Paris", image: "assets/images/paris.jpeg"),
    City(name: "Lyon", image: "assets/images/lyon.jpeg"),
    City(name: "Nice", image: "assets/images/nice.jpeg"),
  ];

  openModal(context) {
    askModal(context, "Hello Veux tu quelque chose?").then((result) {
      print(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.home),
        title: Text("DymaTrip"),
        actions: [Icon(Icons.more_vert)],
      ),
      drawer: DymaDrawer(),
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
            ),
            ElevatedButton(
              onPressed: () {
                openModal(context);
              },
              child: Text("Modal"),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../widgets/dyma_drawer.dart';
import '../../widgets/ask_modal.dart';
import '../../models/city_model.dart';
import 'widgets/city_card.dart';

class HomeView extends StatefulWidget {
  final List<City> cities;
  static const String routeName = "/";

  HomeView({
    this.cities,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeView> {
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
            ...widget.cities.map(
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

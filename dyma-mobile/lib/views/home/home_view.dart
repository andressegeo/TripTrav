import 'package:flutter/material.dart';
import 'package:project_dyma_end/providers/city_provider.dart';
import 'package:provider/provider.dart';
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
  openModal(context) {
    askModal(context, "Hello Veux tu quelque chose?").then(
      (result) {
        print(result);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<City> cities = Provider.of<CityProvider>(context).cities;
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.home),
        title: const Text("DymaTrip"),
        actions: [Icon(Icons.more_vert)],
      ),
      drawer: const DymaDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: cities
              .map(
                (city) => CityCard(
                  city: city,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

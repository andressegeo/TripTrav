import 'package:flutter/material.dart';
import 'package:project_dyma_end/providers/city_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/city_provider.dart';
import '../../widgets/dyma_drawer.dart';
import '../../widgets/ask_modal.dart';
import '../../models/city_model.dart';
import 'widgets/city_card.dart';
import '../../widgets/dyma_loader.dart';

class HomeView extends StatefulWidget {
  static const String routeName = "/";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeView> {
  TextEditingController searchController = TextEditingController();

  @override
  dispose() {
    searchController
        .dispose(); // libérer les ressources when _HomeState est détruit
    super.dispose();
  }

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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(
              horizontal: 14,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Rechercher une ville", // Placeholder
                      prefixIcon: Icon(Icons.search),
                    ),
                    controller: searchController,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => print("object"),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: cities.length > 0
                  ? RefreshIndicator(
                      onRefresh: Provider.of<CityProvider>(context).fetchData,
                      child: ListView.builder(
                        itemCount: cities.length,
                        itemBuilder: (_, i) => CityCard(
                          city: cities[i],
                        ),
                      ),
                    )
                  : DymaLoader(),
            ),
          ),
        ],
      ),
    );
  }
}

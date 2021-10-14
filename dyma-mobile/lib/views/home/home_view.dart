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
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(
          () {}); // Le setState va rebuilder à chaque fois qu'on rentre un mot dans le textField
      // le listener sur le field permet donc de l'écouter et de rebuilder le widget
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   searchController.addListener(() {
  //     setState(() {});
  //   });
  // }

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
    List<City> filteredCities = Provider.of<CityProvider>(context)
        .getFilteredCities(searchController.text);
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.home),
        title: const Text("DymaTrip"),
        actions: [Icon(Icons.more_vert)],
      ),
      drawer: const DymaDrawer(), // (Tiroir) por le menu coulissant de gauche
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
                      hintText: "Rechercher une ville...", // Placeholder
                      prefixIcon: Icon(Icons.search),
                    ),
                    controller: searchController,

                    // onSubmitted will help if we just call the back after click on enter button
                    // In oposite, we have to declare initState who help to rebuil automaticaly after hitting a word on a textField
                    // To conclude for doing autocompletion instantanely, use initState, otherwise, use onSubmitted
                    // onSubmitted: (value) {
                    //   print(value);
                    //   setState(() {});
                    // },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() => searchController.clear());
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: filteredCities.length > 0
                  ? RefreshIndicator(
                      onRefresh: Provider.of<CityProvider>(context).fetchData,
                      child: ListView.builder(
                        itemCount: filteredCities.length,
                        itemBuilder: (_, i) => CityCard(
                          city: filteredCities[i],
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

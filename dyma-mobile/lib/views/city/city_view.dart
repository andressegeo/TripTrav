import 'package:flutter/material.dart';
import '../../providers/trip_provider.dart';
import '../../providers/city_provider.dart';
import 'package:provider/provider.dart';

import '../../models/activity_model.dart';
import '../../models/city_model.dart';
import '../../models/trip_model.dart';

import '../../views/home/home_view.dart';
import '../../widgets/dyma_drawer.dart';
import 'widgets/activity_list.dart';
import 'widgets/trip_activity_list.dart';
import 'widgets/trip_overview.dart';

class CityView extends StatefulWidget {
  static const String routeName = "/city";

  @override
  _CityState createState() => _CityState();

  showContext({required BuildContext context, List<Widget>? children}) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      return Row(
        // Stretch pour que ça prenne toute la hauteur si on est en mode landscape
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children!,
      );
    } else {
      return Column(children: children!);
    }
  }
}

class _CityState extends State<CityView> {
  Trip? myTrip;
  int? index;

  @override
  void initState() {
    super.initState();
    index = 0;
    myTrip = Trip(
      city: null,
      activities: [],
      date: null,
    );
  }

  // Combiner en addition les amounts quand on selectionne dans la cityView
  double get amount {
    return myTrip!.activities.fold(
      0.00,
      (previousValue, element) {
        return previousValue + element.price;
      },
    );
  }

  void setDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 10)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2023),
    ).then(
      (newDate) {
        if (newDate != null) {
          setState(
            () {
              myTrip!.date = newDate;
            },
          );
          print("new date set: ${myTrip!.date}");
        }
      },
    );
  }

  void switchIndex(newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void toggleActivity(Activity activity) {
    setState(
      () {
        myTrip!.activities.contains(activity)
            ? myTrip!.activities.remove(activity)
            : myTrip!.activities.add(activity);
      },
    );
  }

  void deleteTripActivity(Activity activity) {
    print("hooho");
    setState(() {
      if (myTrip!.activities.contains(activity)) {
        myTrip!.activities.remove(activity);
      }
    });
  }

  void saveTrip(String? cityName) async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Voulez vous sauvegarder?"),
          contentPadding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: const Text("Annuler"),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "cancel");
                  },
                ),
                // Petite separation entre les 2 children<Widget>
                const SizedBox(width: 20),
                ElevatedButton(
                  child: const Text(
                    "Sauvegarder",
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "save");
                  },
                ),
              ],
            )
          ],
        );
      },
    );

    if (myTrip!.date == null) {
      print("date null");
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Attention"),
              content: Text("Vous n'avez pas entré de date"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                )
              ],
            );
          });
    } else if (result == "save") {
      // widget.addTrip(myTrip);
      myTrip!.city = cityName;
      Provider.of<TripProvider>(context, listen: false).addTrip(myTrip!);
      Navigator.pushNamed(context, HomeView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? cityName = ModalRoute.of(context)!.settings.arguments as String?;
    City city = Provider.of<CityProvider>(context).getCityByName(cityName);
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.chevron_left),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text("Organisation Voyage"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/activity-form",
                  arguments: cityName,
                );
              })
        ],
      ),
      drawer: const DymaDrawer(),
      body: Container(
        // padding: EdgeInsets.all(10),
        child: widget.showContext(
          context: context,
          children: <Widget>[
            TripOverView(
              setDate: setDate,
              trip: myTrip,
              cityName: city.name,
              cityImage: city.image,
              amount: amount,
            ),
            Expanded(
              child: index == 0
                  ? ActivityList(
                      activities: city.activities,
                      selectedActivities: myTrip!.activities,
                      toggleActivity: toggleActivity,
                    )
                  : TripActivityList(
                      activities: myTrip!.activities,
                      deleteTripActivity: deleteTripActivity,
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.forward),
        onPressed: () {
          saveTrip(city.name);
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index!,
        items: [
          const BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: "Decouverte",
          ),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.stars),
            label: "Mes Activités",
          )
        ],
        onTap: switchIndex,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../models/activity_model.dart';
import '../../models/city_model.dart';
import '../../models/trip_model.dart';

import '../../views/home/home_view.dart';
import '../../widgets/data.dart';
import '../../widgets/dyma_drawer.dart';
import 'widgets/activity_list.dart';
import 'widgets/trip_activity_list.dart';
import 'widgets/trip_overview.dart';

class CityView extends StatefulWidget {
  static const String routeName = "/city";
  final City city;
  final Function addTrip;

  List<Activity> get activities {
    return city.activities;
  }

  CityView({this.city, this.addTrip});
  @override
  _CityState createState() => _CityState();

  showContext({BuildContext context, List<Widget> children}) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      return Row(
        // Stretch pour que ça prenne toute la hauteur si on est en mode landscape
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    } else {
      return Column(children: children);
    }
  }
}

class _CityState extends State<CityView> {
  Trip myTrip;
  int index;

  @override
  void initState() {
    super.initState();
    index = 0;
    myTrip = Trip(
      city: "Paris",
      activities: [],
      date: null,
    );
  }

  List<Activity> get tripActivities {
    return widget.activities
        .where((activity) => myTrip.activities.contains(activity.id))
        .toList();
  }

  // Combiner en addition les amounts quand on selectionne dans la cityView
  double get amount {
    return myTrip.activities.fold(
      0.00,
      (previousValue, element) {
        var activity = widget.activities.firstWhere(
          (activity) {
            return activity.id == element;
          },
        );
        return previousValue + activity.price;
      },
    );
  }

  void setDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2022),
    ).then(
      (newDate) {
        if (newDate != null) {
          setState(
            () {
              myTrip.date = newDate;
            },
          );
          print("new date set: ${myTrip.date}");
        }
      },
    );
  }

  void switchIndex(newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void toggleActivity(String id) {
    setState(() {
      myTrip.activities.contains(id)
          ? myTrip.activities.remove(id)
          : myTrip.activities.add(id);
    });
  }

  void deleteTripActivity(String id) {
    setState(() {
      if (myTrip.activities.contains(id)) {
        myTrip.activities.remove(id);
      }
    });
  }

  void saveTrip() async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Voulez vous sauvegarder?"),
          contentPadding: EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: Text("Annuler"),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "cancel");
                  },
                ),
                // Petite separation entre les 2 children<Widget>
                SizedBox(width: 20),
                ElevatedButton(
                  child: Text(
                    "Sauvegarder",
                    style: TextStyle(color: Colors.white),
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
    if (result == "save") {
      print(myTrip.activities);
      widget.addTrip(myTrip);
      Navigator.pushNamed(context, HomeView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.chevron_left),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text("Organisation Voyage"),
      ),
      drawer: DymaDrawer(),
      body: Container(
        // padding: EdgeInsets.all(10),
        child: widget.showContext(
          context: context,
          children: <Widget>[
            TripOverView(
              setDate: setDate,
              trip: myTrip,
              cityName: widget.city.name,
              amount: amount,
            ),
            Expanded(
              child: index == 0
                  ? ActivityList(
                      activities: widget.activities,
                      selectedActivities: myTrip.activities,
                      toggleActivity: toggleActivity,
                    )
                  : TripActivityList(
                      activities: tripActivities,
                      deleteTripActivity: deleteTripActivity,
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.forward),
        onPressed: saveTrip,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Decouverte",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars),
            label: "Mes Activités",
          )
        ],
        onTap: switchIndex,
      ),
    );
  }
}

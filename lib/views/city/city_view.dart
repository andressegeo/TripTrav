import 'package:flutter/material.dart';
import '../../models/city_model.dart';

import '../../models/activity_model.dart';
import '../../models/trip_model.dart';

import 'widgets/activity_list.dart';
import 'widgets/trip_activity_list.dart';
import 'widgets/trip_overview.dart';
import '../../widgets/data.dart';

class CityView extends StatefulWidget {
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

class _CityState extends State<CityView> with WidgetsBindingObserver {
  // WidgetsBindingObserver es un mixin, car on ne l'hérite pas directement
  // le mot clé "with" ici permet d'heiter implicitement de cette classe
  // qui nous permettra de recupérer les différents state et d'etre notifier à
  // chaque fois qu'il y aura changement d'état de l'app pour éffectuer
  // d'opérations comme liberer la mémoire en supprimant(dispose) la ressource d'un widget
  // si le user venait à state = suspended(inactive, paused,resumed, suspended) l'app

  Trip myTrip;
  int index;
  List<Activity> activities;

  @override
  void initState() {
    super.initState();
    // Ici on enregistre notre widget dans l'engine interne de flutter pour q'il le prenne en compte
    WidgetsBinding.instance.addObserver(this);
    index = 0;
    myTrip = Trip(
      city: "Paris",
      activities: [],
      date: null,
    );
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    // activities = context.dependOnInheritedWidgetOfExactType<Data>().context;
    activities = Data.of(context).activities;
  }

  List<Activity> get tripActivities {
    return activities
        .where((activity) => myTrip.activities.contains(activity.id))
        .toList();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Methode qui sera invoqué automatiquement à chaque fois que l'état va etre amené à évoluer
    super.didChangeAppLifecycleState(state);
    print(state);
  }

  @override
  void dispose() {
    super.dispose();
    // Nétoyer, retirer notre observer
    WidgetsBinding.instance.removeObserver(this);
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

      // print("my activities: ${myTrip.activities}");
    });
  }

  void deleteTripActivity(String id) {
    setState(() {
      if (myTrip.activities.contains(id)) {
        myTrip.activities.remove(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ici on recupère l'argument passé depuis la cityCard du pushNamed
    City city = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [Icon(Icons.more_vert)],
        title: Text("Organisation Voyage"),
      ),
      body: Container(
        // padding: EdgeInsets.all(10),
        child: widget.showContext(
          context: context,
          children: <Widget>[
            TripOverView(
              setDate: setDate,
              trip: myTrip,
              cityName: city.name,
            ),
            Expanded(
              child: index == 0
                  ? ActivityList(
                      activities: activities,
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

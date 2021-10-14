import 'package:flutter/material.dart';
import '../../providers/city_provider.dart';
import '../../views/trip/widgets/trip_weather.dart';
import 'package:provider/provider.dart';
import '../../views/trip/widgets/trip_activities.dart';
import '../../views/trip/widgets/trip_city_bar.dart';
import '../../models/city_model.dart';

class TripView extends StatelessWidget {
  static const String routeName = "/trip";
  @override
  Widget build(BuildContext context) {
    print("BUILD: TripView");
    final String cityName = (ModalRoute.of(context).settings.arguments
        as Map<String, String>)["cityName"];

    final String tripId = (ModalRoute.of(context).settings.arguments
        as Map<String, String>)["tripId"];
    final City city = Provider.of<CityProvider>(context, listen: false)
        .getCityByName(cityName);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TripCityBar(
              city: city,
            ),
            TripWeather(
              cityName: cityName,
            ),
            TripActivities(
              tripId: tripId,
            ),
          ],
        ),
      ),
    );
  }
}

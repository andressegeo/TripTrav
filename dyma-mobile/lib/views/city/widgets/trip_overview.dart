import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_dyma_end/views/city/widgets/trip_overview_city.dart';
import '../../../models/trip_model.dart';

class TripOverView extends StatelessWidget {
  final String cityName;
  final String cityImage;
  final Function setDate;
  final Trip trip;
  final double amount;

  const TripOverView({
    this.cityName,
    this.cityImage,
    this.setDate,
    this.trip,
    this.amount,
  });
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;

    return Container(
      // padding: const EdgeInsets.all(10),
      // height: 200,
      width: orientation == Orientation.landscape ? size.width / 2 : size.width,
      // double.infinity:
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripOverviewCity(
            cityName: cityName,
            cityImage: cityImage,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    trip.date != null
                        ? DateFormat("d/M/y").format(trip.date)
                        : "Choisissez une date",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  child: const Text("Selectionner une date"),
                  onPressed: setDate,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
                    child: const Text(
                  "Prix par personne",
                  style: const TextStyle(fontSize: 20),
                )),
                Text(
                  "$amount \$",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

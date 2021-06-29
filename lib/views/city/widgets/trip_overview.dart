import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/trip_model.dart';

class TripOverView extends StatelessWidget {
  final String cityName;
  final Function setDate;
  final Trip trip;
  final double amount;

  const TripOverView({this.cityName, this.setDate, this.trip, this.amount});
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(10),
      height: 200,
      width: orientation == Orientation.landscape ? size.width / 2 : size.width,
      // double.infinity:
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cityName,
            style: const TextStyle(
              fontSize: 30,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
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
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                  child: const Text(
                "Prix par personne",
                style: const TextStyle(fontSize: 20),
              )),
              Text(
                "$amount \$",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}

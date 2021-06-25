import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/trip_model.dart';

class TripOverView extends StatelessWidget {
  final String cityName;
  final Function setDate;
  final Trip trip;
  double amount;

  TripOverView({this.cityName, this.setDate, this.trip, this.amount});
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(10),
      height: 200,
      width: orientation == Orientation.landscape ? size.width / 2 : size.width,
      // double.infinity:
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cityName,
            style: TextStyle(
              fontSize: 30,
              decoration: TextDecoration.underline,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  trip.date != null
                      ? DateFormat("d/M/y").format(trip.date)
                      : "Choisissez une date",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ElevatedButton(
                child: Text("Selectionner une date"),
                onPressed: setDate,
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                "Prix par personne",
                style: TextStyle(fontSize: 20),
              )),
              Text(
                "$amount \$",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}

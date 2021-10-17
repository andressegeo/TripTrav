import 'package:flutter/material.dart';

class TripOverviewCity extends StatelessWidget {
  final String? cityName;
  final String? cityImage;
  TripOverviewCity({this.cityName, this.cityImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Hero(
            tag: cityName!,
            child: Image.network(
              cityImage!,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black45,
          ),
          Center(
            child: Text(
              cityName!,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                // decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

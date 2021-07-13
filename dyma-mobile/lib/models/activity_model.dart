import 'package:flutter/foundation.dart';

enum ActivityStatus { ongoing, done }

class Activity {
  String id;
  String name;
  String image;
  String city;
  ActivityStatus status;
  double price;

  Activity({
    @required this.id,
    @required this.name,
    @required this.image,
    @required this.city,
    @required this.price,
    this.status = ActivityStatus.ongoing,
  });

  Activity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        image = json["image"],
        city = json["city"],
        price = json["price"].toDouble(),
        status =
            json["status"] == 0 ? ActivityStatus.ongoing : ActivityStatus.done;
}
import 'package:flutter/foundation.dart';

enum ActivityStatus { ongoing, done }

class Activity {
  String? id;
  String name;
  String image;
  String city;
  ActivityStatus status;
  double price;
  LocationActivity? location;

  Activity({
    this.id,
    required this.name,
    required this.image,
    required this.city,
    this.location,
    required this.price,
    this.status = ActivityStatus.ongoing,
  });

  Activity.fromJson(Map<String, dynamic> json)
      : id = json["_id"],
        name = json["name"],
        image = json["image"],
        city = json["city"],
        location = LocationActivity(
            address: json["address"],
            latitude: json["latitude"],
            longitude: json["longitude"]),
        price = json["price"].toDouble(),
        status =
            json["status"] == 0 ? ActivityStatus.ongoing : ActivityStatus.done;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> value = {
      "name": name,
      "image": image,
      "city": city,
      "price": price,
      "address": location!.address,
      "latitude": location!.latitude,
      "longitude": location!.longitude,
      "status": status == ActivityStatus.ongoing ? 0 : 1
    };
    if (id != null) {
      value["_id"] = id;
    }
    return value;
  }
}

class LocationActivity {
  String? address;
  double? latitude;
  double? longitude;

  LocationActivity({
    this.address,
    this.latitude,
    this.longitude,
  });
}

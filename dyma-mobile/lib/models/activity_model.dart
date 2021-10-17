import 'package:flutter/foundation.dart';

enum ActivityStatus { ongoing, done }

class Activity {
  String? id;
  String name;
  String? image;
  String? city;
  ActivityStatus status;
  double? price;

  Activity({
    this.id,
    required this.name,
    required this.image,
    required this.city,
    required this.price,
    this.status = ActivityStatus.ongoing,
  });

  Activity.fromJson(Map<String, dynamic> json)
      : id = json["_id"],
        name = json["name"],
        image = json["image"],
        city = json["city"],
        price = json["price"].toDouble(),
        status =
            json["status"] == 0 ? ActivityStatus.ongoing : ActivityStatus.done;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> value = {
      "name": name,
      "image": image,
      "city": city,
      "price": price,
      "status": status == ActivityStatus.ongoing ? 0 : 1
    };
    if (id != null) {
      value["_id"] = id;
    }
    return value;
  }
}

import 'package:flutter/foundation.dart';

enum ActivityStatus { ongoing, done }

class Activity {
  String name;
  String image;
  String id;
  String city;
  ActivityStatus status;
  double price;

  Activity(
      {@required this.name,
      @required this.image,
      @required this.id,
      @required this.city,
      @required this.price,
      this.status = ActivityStatus.ongoing});
}

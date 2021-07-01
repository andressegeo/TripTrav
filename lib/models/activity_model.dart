import 'package:flutter/foundation.dart';

enum AvtivityStatus { ongoing, done }

class Activity {
  String name;
  String image;
  String id;
  String city;
  AvtivityStatus status;
  double price;

  Activity({
    @required this.name,
    @required this.image,
    @required this.id,
    @required this.city,
    @required this.price,
  }) : status = AvtivityStatus.ongoing;
}

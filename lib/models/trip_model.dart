import 'package:flutter/foundation.dart';
import 'package:project_dyma_end/models/activity_model.dart';

class Trip {
  String city;
  List<Activity> activities;
  DateTime date;
  Trip({
    @required this.city,
    @required this.activities,
    @required this.date,
  });
}

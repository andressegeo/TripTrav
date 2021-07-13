import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:project_dyma_end/models/activity_model.dart';

import 'activity_model.dart';

class Trip {
  String id;
  String city;
  List<Activity> activities;
  DateTime date;
  Trip({
    @required this.city,
    @required this.activities,
    @required this.date,
    @required this.id,
  });

  Trip.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        city = json["city"],
        date = DateTime.parse(json["date"]),
        activities = (json["activities"] as List)
            .map(
              (activityJson) => Activity.fromJson(activityJson),
            )
            .toList();
}

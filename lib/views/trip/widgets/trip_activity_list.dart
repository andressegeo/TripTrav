import 'package:flutter/material.dart';
import '../../../models/activity_model.dart';

class TripActivityList extends StatelessWidget {
  final List<Activity> activities;

  const TripActivityList({Key key, this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, i) {
        return Text(activities[i].name);
      },
    );
  }
}

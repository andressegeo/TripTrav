import 'package:flutter/material.dart';
import '../../../models/activity_model.dart';
import './trip_activity_card.dart';

class TripActivityList extends StatelessWidget {
  final List<Activity> activities;
  final Function deleteTripActivity;

  void showSelectedActivity(Activity activity) {
    // deleteTripActivity(activity.id);
    print(activity.name);
  }

  TripActivityList({this.activities, this.deleteTripActivity});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: activities
            .map(
              (activity) => TripActivityCard(
                key: ValueKey(activity
                    .id), // Pour une clé unique qui toujours etre le meme grace à son ID contrairement à UniqueKey() qui lui va reloader le widget en lui attribuant une new key
                activity: activity,
                deleteTripActivity: deleteTripActivity,
              ),
            )
            .toList(),
      ),
    );
  }
}

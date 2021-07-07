import 'package:flutter/material.dart';
import '../../../models/activity_model.dart';
import '../../city/widgets/activity_card.dart';

class ActivityList extends StatelessWidget {
  final List<Activity> activities;
  final List<Activity> selectedActivities;
  final Function toggleActivity;

  const ActivityList({
    this.activities,
    this.selectedActivities,
    this.toggleActivity,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      // crossAxisCount nbre d'élmt par ligne
      crossAxisCount: 2,
      children: activities
          .map(
            (activity) => ActivityCard(
              activity: activity,
              isSelected: selectedActivities.contains(activity),
              toggleActivity: () {
                toggleActivity(activity);
              },
            ),
          )
          .toList(),
    );
  }
}

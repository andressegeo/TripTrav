import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/trip_provider.dart';
import '../../../models/activity_model.dart';

class TripActivityList extends StatelessWidget {
  final List<Activity> activities;
  final ActivityStatus filter;

  const TripActivityList({Key key, this.activities, this.filter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, i) {
        Activity activity = activities[i];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: filter == ActivityStatus.ongoing
              ? Dismissible(
                  // Pour glisser ou archiver comme sur Gmail
                  // secondaryBackground: Container(
                  //   color: Colors.blue,
                  // ),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  key: ValueKey(activity.id),
                  child: Card(
                    child: ListTile(
                      title: Text(activity.name),
                    ),
                  ),
                  onDismissed: (_) {
                    print("dismiss");
                    print(_);
                    Provider.of<TripProvider>(context, listen: false)
                        .setActivityToDone(activity);
                  },
                )
              : Card(
                  child: ListTile(
                    title: Text(
                      activity.name,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

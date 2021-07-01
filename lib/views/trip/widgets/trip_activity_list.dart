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
        Activity activity = activities[i];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Dismissible(
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
            },
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:project_dyma_end/models/activity_model.dart';
import 'package:project_dyma_end/views/trip/widgets/trip_activity_list.dart';

class TripActivities extends StatelessWidget {
  final List<Activity> activities;

  const TripActivities({Key key, this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: TabBar(
                indicatorColor: Colors.blue[100],
                tabs: [
                  Tab(
                    text: "En cours",
                  ),
                  Tab(
                    text: "Terminé",
                  )
                ],
              ),
            ),
            Container(
              height: 600,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TripActivityList(activities: activities),
                  TripActivityList(activities: activities),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

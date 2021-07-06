import 'package:flutter/material.dart';
import '../../../models/activity_model.dart';
import '../../../views/trip/widgets/trip_activity_list.dart';

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
                  TripActivityList(
                    activities: activities
                        .where((activity) =>
                            activity.status == ActivityStatus.ongoing)
                        .toList(),
                    filter: ActivityStatus.ongoing,
                  ),
                  TripActivityList(
                    activities: activities
                        .where((activity) =>
                            activity.status == ActivityStatus.done)
                        .toList(),
                    filter: ActivityStatus.done,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

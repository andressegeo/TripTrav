import 'package:flutter/material.dart';
import 'package:project_dyma_end/models/trip_model.dart';
import 'package:project_dyma_end/views/google_map/google_map_view.dart';
import 'package:provider/provider.dart';

import '../../../providers/trip_provider.dart';
import '../../../models/activity_model.dart';

class TripActivityList extends StatelessWidget {
  final String? tripId;
  final ActivityStatus? filter;

  const TripActivityList({
    Key? key,
    this.tripId,
    this.filter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("BUILD: TripActivityList");
    return Consumer<TripProvider>(
      builder: (context, tripProvider, child) {
        final Trip trip =
            Provider.of<TripProvider>(context).getTripById(tripId!);
        final List<Activity> activities = trip.activities
            .where((activity) => activity.status == filter)
            .toList();
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
                      child: InkWell(
                        child: Card(
                          child: ListTile(
                            title: Text(activity.name),
                          ),
                        ),
                        onTap: () => Navigator.pushNamed(
                          context,
                          GoogleMapView.routeName,
                          arguments: {
                            "activityId": activity.id,
                            "tripId": trip.id!,
                          },
                        ),
                      ),
                      confirmDismiss: (_) {
                        return Provider.of<TripProvider>(context, listen: false)
                            .updateTrip(trip, activity.id!)
                            .then((_) => true)
                            .catchError((_) {
                          print("error then");
                          print(_);
                          return false;
                        });
                      },
                      // onDismissed: (_) {
                      //   print("dismiss");
                      //   print(_);
                      //   Provider.of<TripProvider>(context, listen: false)
                      //       .updateTrip(trip, activity.id);
                      // },
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
      },
    );
  }
}

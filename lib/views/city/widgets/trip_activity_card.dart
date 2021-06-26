import 'dart:math';

import 'package:flutter/material.dart';
import '../../../models/activity_model.dart';

class TripActivityCard extends StatefulWidget {
  final Activity activity;
  final Function deleteTripActivity;

  Color getColor() {
    const colors = [Colors.blue, Colors.red];
    return colors[Random().nextInt(2)];
  }

  TripActivityCard({Key key, this.activity, this.deleteTripActivity})
      : super(key: key);

  // const TripActivityCard({Key? key}) : super(key: key);

  @override
  _TripActivityCardState createState() => _TripActivityCardState();
}

class _TripActivityCardState extends State<TripActivityCard> {
  initState() {
    color = widget.getColor();
    super.initState();
  }

  Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(widget.activity.image),
        ),
        title: Text(
          widget.activity.name,
          // style: TextStyle(color: color),
          // ALons chercher les caractéristiques définis dans notre theme Material
          // Qui est un inheritedWidget
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(widget.activity.city),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: color,
          onPressed: () {
            widget.deleteTripActivity(widget.activity.id);
            // showSnackBar is depracated, so use
            // Scaffold.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(
            //       "Activité ${widget.activity.name} supprimée",
            //       textAlign: TextAlign.center,
            //     ),
            //     backgroundColor: Colors.red,
            //   ),
            // );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Activité ${widget.activity.name} supprimée",
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: "Annuler",
                  textColor: Colors.white,
                  onPressed: () {
                    print("Undo - Activité ${widget.activity.name} supprimée");
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

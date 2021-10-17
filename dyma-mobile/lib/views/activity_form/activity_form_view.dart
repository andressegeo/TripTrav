import 'package:flutter/material.dart';
import 'package:project_dyma_end/views/activity_form/widgets/activity_form.dart';
import 'package:project_dyma_end/widgets/dyma_drawer.dart';

class ActivityFormView extends StatelessWidget {
  static const String routeName = "/activity-form";

  @override
  Widget build(BuildContext context) {
    String cityName = ModalRoute.of(context)!.settings.arguments as String;
    print(cityName);
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une activité"),
      ),
      drawer: const DymaDrawer(),
      body: ActivityForm(cityName: cityName),
    );
  }
}

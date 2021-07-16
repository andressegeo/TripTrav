import 'package:flutter/material.dart';
import 'package:project_dyma_end/models/activity_model.dart';

class ActivityForm extends StatefulWidget {
  final String cityName;

  ActivityForm({this.cityName});
  @override
  _ActivityFormState createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FormState get form {
    return formKey.currentState;
  }

  Activity newActivity;

  @override
  void initState() {
    newActivity = Activity(
      name: null,
      price: 0,
      image: null,
      city: widget.cityName,
      status: ActivityStatus.ongoing,
    );
    super.initState();
  }

  void submitForm() {
    print(newActivity.toJson());
    if (form.validate()) {
      form.save();
    } else {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value.isEmpty) return "Remplissez le Nom";
                return null;
              },
              decoration: InputDecoration(
                hintText: "Nom",
              ),
              onSaved: (value) => newActivity.name = value,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) return "Remplissez le Prix";
                return null;
              },
              decoration: InputDecoration(
                hintText: "Prix",
              ),
              onSaved: (value) => newActivity.price = double.parse(value),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value.isEmpty) return "Remplissez l'Url ";
                return null;
              },
              decoration: InputDecoration(
                hintText: "Url Image",
              ),
              onSaved: (value) => newActivity.image = value,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text("Annuler"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: Text("Sauvergarder"),
                  onPressed: submitForm,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

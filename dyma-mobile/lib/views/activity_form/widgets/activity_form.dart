import 'package:flutter/material.dart';
import 'package:project_dyma_end/models/activity_model.dart';

class ActivityForm extends StatefulWidget {
  final String cityName;

  ActivityForm({this.cityName});
  @override
  _ActivityFormState createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _priceFocusNode;
  FocusNode _urlFocusNode;
  FormState get form {
    return _formKey.currentState;
  }

  Activity _newActivity;

  @override
  void initState() {
    _newActivity = Activity(
      name: null,
      price: 0,
      image: null,
      city: widget.cityName,
      status: ActivityStatus.ongoing,
    );
    _priceFocusNode = FocusNode();
    _urlFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  void submitForm() {
    print(_newActivity.toJson());
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
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              validator: (value) {
                if (value.isEmpty) return "Remplissez le Nom";
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "Nom",
              ),
              onSaved: (value) => _newActivity.name = value,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
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
              textInputAction: TextInputAction.next,
              focusNode: _priceFocusNode,
              decoration: InputDecoration(
                labelText: "Prix",
              ),
              onSaved: (value) => _newActivity.price = double.parse(value),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_urlFocusNode);
              },
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
              focusNode: _urlFocusNode,
              decoration: InputDecoration(
                hintText: "Url Image",
              ),
              onSaved: (value) => _newActivity.image = value,
              onFieldSubmitted: (_) => submitForm(),
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

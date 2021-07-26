import 'package:flutter/material.dart';
import 'package:project_dyma_end/models/activity_model.dart';
import 'package:project_dyma_end/providers/city_provider.dart';
import 'package:provider/provider.dart';

class ActivityForm extends StatefulWidget {
  final String cityName;

  ActivityForm({@required this.cityName});
  @override
  _ActivityFormState createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _priceFocusNode;
  FocusNode _urlFocusNode;
  Activity _newActivity;
  bool _isLoading = false;
  FormState get form {
    return _formKey.currentState;
  }

  @override
  void initState() {
    _newActivity = Activity(
      city: widget.cityName,
      name: "",
      price: 0,
      image: "",
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

  Future<void> submitForm() async {
    try {
      CityProvider cityProvider = Provider.of<CityProvider>(
        context,
        listen: false,
      );
      form.validate();
      if (form.validate()) {
        _formKey.currentState.save();
        setState(() {
          _isLoading = true;
        });
        await cityProvider.addActivityToCity(_newActivity);
        Navigator.pop(context);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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
              onSaved: (value) {
                _newActivity.price = double.parse(value);
              },
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
              onSaved: (value) {
                _newActivity.image = value;
              },
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
                  onPressed: _isLoading ? null : submitForm,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

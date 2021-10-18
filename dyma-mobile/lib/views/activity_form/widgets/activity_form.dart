import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_dyma_end/models/activity_model.dart';
import 'package:project_dyma_end/providers/city_provider.dart';
import 'package:project_dyma_end/views/activity_form/widgets/activity_form_image_picker.dart';
import 'package:provider/provider.dart';

class ActivityForm extends StatefulWidget {
  final String cityName;

  ActivityForm({required this.cityName});
  @override
  _ActivityFormState createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _priceFocusNode;
  late FocusNode _urlFocusNode;
  late Activity _newActivity;
  String? _nameInputAsync;
  final TextEditingController _urlControler = TextEditingController();
  bool _isLoading = false;
  FormState get form {
    return _formKey.currentState!;
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

  void updateUrlField(String url) {
    setState(() {
      _urlControler.text = url;
    });
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    print("dude");
    try {
      CityProvider cityProvider = Provider.of<CityProvider>(
        context,
        listen: false,
      );
      print("bruu");
      form.validate();
      print("kiiii");
      _formKey.currentState!.save();
      print("jkllkj");
      setState(() => _isLoading = true);
      print("menn");
      _nameInputAsync = await cityProvider.verifyIfActivityNameIsUnique(
        widget.cityName,
        _newActivity.name,
      );
      // https: //storage.googleapis.com/can-2k19.appspot.com/catacombes.jpeg

      print("menn");
      if (form.validate()) {
        print("form validate begin");
        await cityProvider.addActivityToCity(_newActivity);
        Navigator.pop(context);
      } else {
        print("else form val");
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
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "Nom",
              ),
              validator: (value) {
                print("value: $value");
                print("orange");
                print("_nameInputAsynccc: $_nameInputAsync");
                if (value == null || value.isEmpty) {
                  print("Remplissez le Nom");
                  return "Remplissez le Nom";
                } else if (_nameInputAsync != "OK") {
                  print("ffdgkh");
                  print(_nameInputAsync);
                  return _nameInputAsync;
                } else {
                  print("I return null men");
                  return null;
                }
              },
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_priceFocusNode),
              onSaved: (value) => _newActivity.name = value!,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              focusNode: _priceFocusNode,
              decoration: InputDecoration(
                hintText: "Prix",
              ),
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_urlFocusNode),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Remplissez le Prix";
                }
                return null;
              },
              onSaved: (value) => _newActivity.price = double.parse(value!),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.url,
              focusNode: _urlFocusNode,
              controller: _urlControler,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Remplissez l'Url ";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Url Image",
              ),
              onSaved: (value) => _newActivity.image = value!,
            ),
            SizedBox(
              height: 10,
            ),
            ActivityFormImagePicker(updateUrl: updateUrlField),
            SizedBox(
              height: 30,
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
                  child: Text("Sauvegarder"),
                  onPressed: _isLoading
                      ? null
                      : submitForm, // Si ça load, on return null, else on submit
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_dyma_end/models/activity_model.dart';
import 'package:project_dyma_end/providers/city_provider.dart';
import 'package:project_dyma_end/views/activity_form/widgets/activity_form_autocomplete.dart';
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
  late FocusNode _addressFocusNode;
  late Activity _newActivity;
  late String? _nameInputAsync;
  final TextEditingController _urlControler = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
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
      location: LocationActivity(
        address: "",
        latitude: 0,
        longitude: 0,
      ),
      status: ActivityStatus.ongoing,
    );
    _priceFocusNode = FocusNode();
    _urlFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _nameInputAsync = null;
    _addressFocusNode.addListener(() async {
      if (_addressFocusNode.hasFocus) {
        var location = await showInputAutoComplete(context);
        print("location: ${location?.address}");
        _newActivity.location = location;
        setState(() {
          if (location != null) {
            _addressController.text = location.address!;
          }
        }); // print("location: $location");
        // Pour revenir lorsqu'on Navigator.pop retour en arrière
        // Il faut focus sur un autre champ pour que ça fonctionne
        // Si non, il va no focus puis revenir se focus sur la Dialog du showInputAutoComplete
        _urlFocusNode.requestFocus();
      } else {
        print("no focus");
      }
    });
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
    _addressFocusNode.dispose();
    _urlControler.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    print("dude");
    try {
      CityProvider cityProvider = Provider.of<CityProvider>(
        context,
        listen: false,
      );
      form.validate();
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      _nameInputAsync = await cityProvider.verifyIfActivityNameIsUnique(
        widget.cityName,
        _newActivity.name,
      );
      if (form.validate()) {
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

  // installer le paquet location pour faire fonctionner le gps
  void _getCurrentLocation() async {
    print("get locaton");
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
                if (value == null || value.isEmpty) {
                  return "Remplissez le Nom";
                } else if (_nameInputAsync != "OK") {
                  print(_nameInputAsync);
                  return _nameInputAsync;
                } else {
                  return null;
                }
              },
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_priceFocusNode),
              onSaved: (value) => _newActivity.name = value!,
            ),
            SizedBox(
              height: 30,
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
              focusNode: _addressFocusNode,
              controller: _addressController,
              decoration: InputDecoration(
                hintText: "Adresse",
              ),
              onSaved: (value) => _newActivity.location!.address = value!,
            ),
            SizedBox(
              height: 10,
            ),
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.gps_fixed),
              label: Text("Utiliser ma position actuelle"),
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
              height: 30,
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

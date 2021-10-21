import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_dyma_end/models/activity_model.dart';
import 'package:project_dyma_end/providers/trip_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapView extends StatefulWidget {
  static const String routeName = "/google-map";
  const GoogleMapView({Key? key}) : super(key: key);

  @override
  _GoogleMapViewState createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  bool _isLoaded = false;
  late Activity _activity;
  GoogleMapController? _controller;
  @override
  void didChangeDependencies() {
    if (!_isLoaded) {
      var arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
      _activity =
          Provider.of<TripProvider>(context, listen: false).getActivityByIds(
        activityId: arguments['activityId']!,
        tripId: arguments['tripId']!,
      );
    }
    super.didChangeDependencies();
  }

  get _activityLatLng {
    return LatLng(
      _activity.location!.latitude!,
      _activity.location!.longitude!,
    );
  }

  get _initialCameraPosition {
    return CameraPosition(
      // le bearing tourne la carte suivant l'angle que tu lui passes
      // bearing: 90,
      target: _activityLatLng,
      zoom: 16.0,
    );
  }

  Future<void> _openUrl() async {
    final String _url;
    if (Platform.isAndroid) {
      print("this is an android Os");
      _url = 'google.navigation:q=${_activity.location!.address}';
    } else {
      print("this is an IOS Os");
      _url =
          'https://maps.apple.com/?q=${_activity.location!.latitude},${_activity.location!.longitude}';
    }
    print("urll: $_url");
    if (await canLaunch(_url)) {
      await launch(_url);
    } else if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw "can not launch _url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_activity.name),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) => _controller = controller,
        markers: Set.of(
          [
            Marker(
              markerId: MarkerId("123"), // Le markerId doit être unique
              flat: true,
              position: _activityLatLng,
              onTap: () => print("hello"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.directions_car),
        onPressed: _openUrl,
        label: Text("Go"),
      ),
    );
  }
}

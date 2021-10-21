import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_dyma_end/models/activity_model.dart';
import 'package:project_dyma_end/providers/trip_provider.dart';
import 'package:provider/provider.dart';

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

  get _initialCameraPosition {
    return CameraPosition(
      // le bearing tourne la carte suivant l'angle que tu lui passes
      // bearing: 90,
      target: LatLng(
        _activity.location!.latitude!,
        _activity.location!.longitude!,
      ),
      zoom: 16.0,
    );
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
      ),
    );
  }
}

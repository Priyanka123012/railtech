import 'package:faecauth/extension/appbar_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeofenceScreen extends StatefulWidget {
  @override
  _GeofenceScreenState createState() => _GeofenceScreenState();
}

class _GeofenceScreenState extends State<GeofenceScreen> {
  late GoogleMapController mapController;
  final Set<Polygon> _polygons = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGeofenceData();
  }

  Future<void> _fetchGeofenceData() async {
    final url = Uri.parse('http://rapi.railtech.co.in/api/Geofence/get');
    final response = await http.post(url, body: {});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['StatusCode'] == 1) {
        String geofencePath = data['TDS']['GeofencePath'];
        print("geofencePath${geofencePath}");
        _setGeofencePolygon(geofencePath);
      }
    } else {
      print('Failed to load geofence data');
    }

    setState(() {
      isLoading = false;
    });
  }

  void _setGeofencePolygon(String geofencePath) {
    List<LatLng> points = _parseGeofencePath(geofencePath);
    setState(() {
      _polygons.add(
        Polygon(
          polygonId: PolygonId('geofence_polygon'),
          points: points,
          strokeWidth: 2,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.15),
        ),
      );
    });
  }

  List<LatLng> _parseGeofencePath(String path) {
    List<LatLng> points = [];
    List<String> coordinates = path.split(',');
    for (int i = 0; i < coordinates.length; i += 2) {
      double lat = double.parse(coordinates[i]);
      double lng = double.parse(coordinates[i + 1]);
      points.add(LatLng(lat, lng));
    }
    return points;
  }

  String? lattitude = "Getting Status.........";

  void _checkGeofence() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng currentPosition = LatLng(position.latitude, position.longitude);
    bool isWithinGeofence =
        _isPointInPolygon(currentPosition, _polygons.first.points);
    if (isWithinGeofence) {
      setState(() {
        lattitude = 'User is Under Geofence';
      });
    } else {
      setState(() {
        lattitude = 'User is outside the geofence';
      });
    }
  }

  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int n = polygon.length;
    bool isWithin = false;
    int j = n - 1;

    for (int i = 0; i < n; i++) {
      if ((polygon[i].longitude > point.longitude) !=
              (polygon[j].longitude > point.longitude) &&
          (point.latitude <
              (polygon[j].latitude - polygon[i].latitude) *
                      (point.longitude - polygon[i].longitude) /
                      (polygon[j].longitude - polygon[i].longitude) +
                  polygon[i].latitude)) {
        isWithin = !isWithin;
      }
      j = i;
    }

    return isWithin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _checkGeofence,
            icon: Icon(Icons.my_location),
          )
        ],
        title: Text(
          'Geofence Map',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ).gradientBackground(withActions: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Card(
            shape: RoundedRectangleBorder(),
            color: lattitude != "User is Under Geofence"
                ? Colors.green.shade200
                : Colors.red.shade200,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                lattitude.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: lattitude == "User is Under Geofence"
                        ? Colors.green
                        : Colors.red),
              ),
            ),
          )),
          // Container(
          //   height: Get.height * 0.6,
          //   child: _isLoading
          //       ? Center(child: CircularProgressIndicator())
          //       : GoogleMap(
          //           initialCameraPosition: CameraPosition(
          //             target: LatLng(26.863168, 81.003394),
          //             zoom: 15,
          //           ),
          //           polygons: _polygons,
          //           onMapCreated: (GoogleMapController controller) {
          //             mapController = controller;
          //           },
          //         ),
          // ),
        ],
      ),
    );
  }
}

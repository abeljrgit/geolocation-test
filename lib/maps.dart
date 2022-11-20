import 'package:flutter/material.dart';
import 'package:geolocation_test/api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GeolocationImplementation extends StatefulWidget {
  const GeolocationImplementation({super.key});

  @override
  State<GeolocationImplementation> createState() =>
      _GeolocationImplementationState();
}

class _GeolocationImplementationState extends State<GeolocationImplementation> {
  final GlobalKey _flutterMapKey = GlobalKey();
  double latitudeValue = 0.0;
  double longitudeValue = 0.0;

  void checkPermision() async {
    LocationPermission permission = await Geolocator.checkPermission();
  }

  void getCurrentLocation() async {
    Position currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    getAddressBasedOnLatLng(currentLocation);
    setState(() {
      latitudeValue = currentLocation.latitude;
      longitudeValue = currentLocation.longitude;
    });
  }

  void getAddressBasedOnLatLng(Position currentLocationValue) async {
    var aa = ArcgisApi();
    print(currentLocationValue.latitude);
    print(currentLocationValue.longitude);
    dynamic res = await aa.getReversedGeocode(
        currentLocationValue.latitude.toString(),
        currentLocationValue.longitude.toString());
    print(res);
  }

  @override
  void initState() {
    checkPermision();
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FleafletMap(
      key: _flutterMapKey,
      latitudeValue: latitudeValue,
      longitudeValue: longitudeValue,
    );
  }
}

/////////////////////////////////////
/// Fleaflet Implementation
/////////////////////////////////////

class FleafletMap extends StatefulWidget {
  const FleafletMap({
    super.key,
    required this.latitudeValue,
    required this.longitudeValue,
  });

  final double latitudeValue;
  final double longitudeValue;

  @override
  State<FleafletMap> createState() => _FleafletMapState();
}

class _FleafletMapState extends State<FleafletMap> {
  final MapController _mapController = MapController();

  Size? flutterMapBoxSize;

  final double pointSize = 40.0;
  double pointX = 0.0;
  double pointY = 0.0;

  getSize() {
    print(widget.key);

    setState(() {});
  }

  @override
  void didUpdateWidget(covariant FleafletMap oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(
        LatLng(widget.latitudeValue, widget.longitudeValue),
        9.2,
      );
    });
    pointX = widget.latitudeValue;
    pointY = widget.longitudeValue;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    getSize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(51.509364, -0.128928),
            zoom: 9.2,
          ),
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap contributors',
              onSourceTapped: null,
            ),
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
          ],
        ),
        const Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.crop_free,
              size: 16,
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }
}

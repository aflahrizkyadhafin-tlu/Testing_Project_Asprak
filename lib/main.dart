import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_api/searchLocation.dart';
import 'package:mapbox_api/userLocation.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(
    "pk.eyJ1IjoiYWZsYWgtdGVsdSIsImEiOiJjbWlndjZpOXMwYmx0M2NxczFtMXFzM3FkIn0.1PzbFxXk49ob_oqlkygLkg",
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  MapboxMap? _mapboxMap;
  Future<List<Map<String, dynamic>>> searchResult = searchLocation("");
  TextEditingController _searchLocationTextController = TextEditingController();

  void updateSearchResult(String suggestPlace) {
    searchResult = searchLocation(suggestPlace);
  }

  Future<void> enableLocation() async {
    var status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      _mapboxMap?.location.updateSettings(
        LocationComponentSettings(enabled: true, pulsingEnabled: true),
      );
    } else {
      print("Permission Denied");
    }
  }

  void onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    enableLocation();
    final userPos = await getUserLocation();
    await _mapboxMap!.compass.updateSettings(
      CompassSettings(enabled: true, position: OrnamentPosition.BOTTOM_RIGHT),
    );
    await _mapboxMap!.scaleBar.updateSettings(
      ScaleBarSettings(
        enabled: true,
        position: OrnamentPosition.BOTTOM_LEFT,
        marginBottom: 30,
      ),
    );
    moveToLocation(Position(userPos.longitude, userPos.latitude));
  }

  void moveToLocation(Position pos) async {
    await _mapboxMap!.flyTo(
      CameraOptions(zoom: 15, center: Point(coordinates: pos)),
      MapAnimationOptions(duration: 1000),
    );
  }

  PointAnnotationManager? _annotationManager;

  void createMarker(Position pos) async {
    _annotationManager ??= await _mapboxMap!.annotations
        .createPointAnnotationManager();

    await _annotationManager!.deleteAll();

    final ByteData byteData = await rootBundle.load('assets/marker.png');
    final Uint8List imageData = byteData.buffer.asUint8List();

    await _annotationManager!.create(
      PointAnnotationOptions(
        image: imageData,
        iconSize: 1,
        geometry: Point(coordinates: pos),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              MapWidget(onMapCreated: onMapCreated),
              FutureBuilder(
                future: searchResult,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchLocationTextController,
                                onSubmitted: (value) =>
                                    setState(() => updateSearchResult(value)),
                                decoration: InputDecoration(
                                  hintText: "Cari lokasi...",
                                  prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(14),
                                ),
                              ),
                            ),

                            SizedBox(height: 8),

                            if (snapshot.hasData)
                              ...snapshot.data!.map(
                                (item) => Card(
                                  margin: EdgeInsets.only(bottom: 8),
                                  elevation: 1,
                                  child: ListTile(
                                    dense: true,
                                    leading: Icon(
                                      Icons.place,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      item["name"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      item["address"],
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    onTap: () => setState(() {
                                      createMarker(
                                        Position(
                                          item["coordinat"].long,
                                          item["coordinat"].lat,
                                        ),
                                      );
                                      moveToLocation(
                                        Position(
                                          item["coordinat"].long,
                                          item["coordinat"].lat,
                                        ),
                                      );
                                      updateSearchResult("");
                                      _searchLocationTextController.clear();
                                    }),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prcarpolimi/models/carModel.dart';

class PassMarker {
  static Set<Marker> markerToPass = {};
  static CarModel carModel = CarModel();
  static bool driveInserted = false;
  static int markerId = 0;
  static bool from = true;
  static bool hpOrNot = true;
}

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prcarpolimi/models/carModel.dart';

class PassMarker {
  static Set<Marker> markerToPass = {};
  static int countMarker = 0;
  static CarModel carModel = CarModel();
}

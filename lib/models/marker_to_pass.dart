import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prcarpolimi/models/carModel.dart';

class PassMarker {
  static Set<Marker> markerToPass = {};
  static CarModel carModel = CarModel();
  static int markerId = 0;
  static bool from = true;
  static bool hpOrNot = true;
  static List<String> cid = [];
  static List<String> uidFriend = [];
  static List<String> bookId = [];
  static List<String> status = [];
  static int photoCount = 0;
  static String cidAdd = '';
  static bool? useMobileLayout;
  static String namePopup = '';
}

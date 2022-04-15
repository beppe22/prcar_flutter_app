class VehicleDataModel {
  String? brand;
  List? models;

  VehicleDataModel({this.brand, this.models});

  VehicleDataModel.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    models = json['models'];
  }
}

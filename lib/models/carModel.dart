// ignore_for_file: file_names

class CarModel {
  String? cid;
  String? model;
  String? color;
  int? seats;

  CarModel({this.cid, this.model, this.color, this.seats});

  //receiving data from server
  factory CarModel.fromMap(map) {
    return CarModel(
        cid: map['cid'],
        model: map['model'],
        color: map['color'],
        seats: map['seats']);
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {'cid': cid, 'model': model, 'color': color, 'seats': seats};
  }
}

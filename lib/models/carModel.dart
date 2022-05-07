// ignore_for_file: file_names

class CarModel {
  String? cid;
  String? model;
  String? vehicle;
  String? seats;
  String? price;
  String? fuel;
  String? activeOrNot;
  String? position;
  String? uid;

  CarModel({
    this.cid,
    this.model,
    this.seats,
    this.vehicle,
    this.price,
    this.fuel,
    this.activeOrNot,
    this.position,
    this.uid,
  });

  //receiving data from server
  factory CarModel.fromMap(map) {
    return CarModel(
        cid: map['cid'],
        model: map['model'],
        seats: map['seats'],
        vehicle: map['veicol'],
        price: map['price'],
        fuel: map['fuel'],
        activeOrNot: map['active?'],
        position: map['position'],
        uid: map['uid']);
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'cid': cid,
      'model': model,
      'veicol': vehicle,
      'seats': seats,
      'fuel': fuel,
      'price': price,
      'active?': activeOrNot,
      'position': position,
      'uid': uid,
    };
  }
}

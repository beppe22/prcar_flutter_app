class BookingInModel {
  String? uidOwner;
  String? cid;
  String? date;
  String? uidBooking;

  BookingInModel({
    this.uidOwner,
    this.cid,
    this.date,
    this.uidBooking,
  });

  //receiving data from server
  factory BookingInModel.fromMap(map) {
    return BookingInModel(
        uidOwner: map['uidOwner'],
        cid: map['cid'],
        date: map['date'],
        uidBooking: map['uidBooking']);
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uidOwner': uidOwner,
      'cid': cid,
      'date': date,
      'uidBooking': uidBooking,
    };
  }
}

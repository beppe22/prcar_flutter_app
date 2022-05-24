class BookingModel {
  String? uidOwner;
  String? cid;
  String? date;
  String? uidBooking;
  String? bookingId;
  String? status;

  BookingModel(
      {this.uidOwner,
      this.cid,
      this.date,
      this.uidBooking,
      this.bookingId,
      this.status});

  //receiving data from server
  factory BookingModel.fromMap(map) {
    return BookingModel(
        uidOwner: map['uidOwner'],
        cid: map['cid'],
        date: map['date'],
        uidBooking: map['uidBooking'],
        bookingId: map['bookingId'],
        status: map['status']);
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uidOwner': uidOwner,
      'cid': cid,
      'date': date,
      'uidBooking': uidBooking,
      'bookingId': bookingId,
      'status': status
    };
  }
}

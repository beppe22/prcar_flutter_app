// ignore_for_file: file_names

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? isConfirmed;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.secondName,
    this.isConfirmed,
  });

  //receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        secondName: map['secondName'],
        isConfirmed: map['isConfirmed']);
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'isConfirmed': isConfirmed,
    };
  }
}

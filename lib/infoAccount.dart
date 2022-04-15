// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:prcarpolimi/models/userModel.dart';

class InfoAccount extends StatelessWidget {
  UserModel usermodel;
  InfoAccount(this.usermodel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'About your account',
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.redAccent,
                title: const Text('PrCar'),
                automaticallyImplyLeading: false,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    })),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(usermodel.email.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30.8,
                          fontWeight: FontWeight.normal)),
                  Text(usermodel.firstName.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17.8,
                          fontWeight: FontWeight.normal)),
                  Text(usermodel.secondName.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17.8,
                          fontWeight: FontWeight.normal))
                ])));
  }
}

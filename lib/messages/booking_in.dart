// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BookingInPage extends StatefulWidget {
  List<String> res;
  BookingInPage({Key? key, required this.res}) : super(key: key);

  @override
  State<BookingInPage> createState() => BookingInPageState(res);
}

class BookingInPageState extends State<BookingInPage> {
  List<String> res;
  BookingInPageState(this.res);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text('Booking-In'),
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const SizedBox(height: 40),
              (res.isEmpty)
                  ? Container(
                      height: 70,
                      width: 350,
                      child: const Text('No reservation yet :(',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(width: 5.0, color: Colors.redAccent),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 6,
                                blurRadius: 2)
                          ]))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: res == [] ? 0 : res.length,
                      itemBuilder: (context, index) {
                        return Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  Container(
                                      height: 110,
                                      width: 350,
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 15, 20, 15),
                                      child: (MaterialButton(
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                            title: const Text(
                                                                'What do you want to do?',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .redAccent,
                                                                    fontSize:
                                                                        25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                            content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const SizedBox(
                                                                      height:
                                                                          30),
                                                                  Container(
                                                                      height:
                                                                          70,
                                                                      width:
                                                                          250,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .redAccent,
                                                                          border: Border.all(
                                                                              width: 5.0,
                                                                              color: Colors.grey)),
                                                                      child: MaterialButton(
                                                                        onPressed:
                                                                            () async {
                                                                          final splitted =
                                                                              res[index].split('.');
                                                                          String
                                                                              date =
                                                                              splitted[0];
                                                                          DateTime
                                                                              dayEnd =
                                                                              DateFormat("dd/MM/yyyy").parse(date.substring(11));
                                                                          if (dayEnd.compareTo(DateTime.now()) <
                                                                              0) {
                                                                            //eliminazione messaggio
                                                                          } else {
                                                                            Fluttertoast.showToast(
                                                                                msg: 'Impossible operation: you can\'t eliminate this message while the reservation isn\'t finished :(',
                                                                                fontSize: 20);
                                                                          }
                                                                        },
                                                                        child: const Text(
                                                                            'Cancellation',
                                                                            textAlign: TextAlign
                                                                                .center,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18,
                                                                                color: Colors.black)),
                                                                        shape: ContinuousRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(30)),
                                                                      )),
                                                                  const SizedBox(
                                                                      height:
                                                                          30),
                                                                  Container(
                                                                      height:
                                                                          70,
                                                                      width:
                                                                          250,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .redAccent,
                                                                          border: Border.all(
                                                                              width: 5.0,
                                                                              color: Colors.grey)),
                                                                      child: MaterialButton(
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'Return',
                                                                            textAlign: TextAlign
                                                                                .center,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18,
                                                                                color: Colors.black)),
                                                                        shape: ContinuousRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(30)),
                                                                      ))
                                                                ])));
                                          },
                                          child: Text(
                                              _seeReservation(
                                                  index.toString(), res[index]),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.redAccent)))),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 5.0, color: Colors.grey),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.white,
                                                spreadRadius: 6,
                                                blurRadius: 2)
                                          ]))
                                ]));
                      })
            ])));
  }

  String _seeReservation(String i, String message) {
    final splitted = message.split('.');
    String date = splitted[0];
    String car = splitted[1];
    DateTime dayStart = DateFormat("dd/MM/yyyy").parse(date.substring(0, 10));
    DateTime dayEnd = DateFormat("dd/MM/yyyy").parse(date.substring(11));
    if (dayStart.compareTo(DateTime.now()) > 0) {
      return i + '. Date: ' + date + '\n Model: ' + car + '\n Status: Soon';
    }
    if (dayStart.compareTo(DateTime.now()) <= 0 &&
        dayEnd.compareTo(DateTime.now()) > 0) {
      return i + '. Date: ' + date + '\n Model: ' + car + '\n Status: Active';
    } else {
      return i + '. Date: ' + date + '\n Model: ' + car + '\n Status: Complete';
    }
  }
}

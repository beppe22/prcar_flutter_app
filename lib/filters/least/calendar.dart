// ignore_for_file: no_logic_in_create_state, must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prcarpolimi/models/marker_to_pass.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  List<String> blackout;
  Calendar({Key? key, required this.blackout}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState(blackout);
}

class _CalendarState extends State<Calendar> {
  String _startDate = '', _endDate = '';
  final DateRangePickerController _controller = DateRangePickerController();
  List<String> blackout;
  _CalendarState(this.blackout);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: const Text('Calendar'),
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, ['', '']);
              }),
        ),
        backgroundColor: Colors.white,
        body: Column(children: [
          const SizedBox(height: 120),
          SfDateRangePicker(
              view: DateRangePickerView.month,
              controller: _controller,
              onSelectionChanged: selectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              enablePastDates: false,
              extendableRangeSelectionDirection:
                  ExtendableRangeSelectionDirection.forward,
              monthViewSettings: DateRangePickerMonthViewSettings(
                  blackoutDates: _takeDateList(blackout)),
              monthCellStyle: const DateRangePickerMonthCellStyle(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
                blackoutDateTextStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              backgroundColor: Colors.blueGrey.shade200),
          const SizedBox(height: 70),
          Container(
              width: double.maxFinite,
              height: 50,
              margin: const EdgeInsets.only(
                  top: 10, left: 40, right: 40, bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20)),
              child: MaterialButton(
                  onPressed: () async {
                    if (_startDate == '' && _endDate == '') {
                      Fluttertoast.showToast(
                          msg: 'No date selected :(', fontSize: 20);
                    } else {
                      if (await _checkFreeDate(
                          _takeDateList(blackout),
                          DateFormat("dd/MM/yyyy").parse(_startDate),
                          DateFormat("dd/MM/yyyy").parse(_endDate))) {
                        Navigator.pop(context, [_startDate, _endDate]);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Don't select day already occupied :(",
                            fontSize: 20);
                      }
                    }
                  },
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: const Text("Ok",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))))
        ]));
  }

  List<DateTime> _takeDateList(List<String> date) {
    if (PassMarker.hpOrNot) {
      List<DateTime> blackList = [];
      if (date.isEmpty) {
        return [];
      }
      for (int i = 0; i < date.length; i++) {
        final splitted = date[i].split('-');
        String startS = splitted[0];
        String endS = splitted[1];
        DateTime start = DateFormat("dd/MM/yyyy").parse(startS);
        DateTime end = DateFormat("dd/MM/yyyy").parse(endS);
        while (start.compareTo(end) != 0) {
          blackList.add(start);
          start = start.add(const Duration(days: 1));
        }
        blackList.add(end);
      }
      return blackList;
    } else {
      return [];
    }
  }

  Future<bool> _checkFreeDate(
      List<DateTime> date, DateTime start, DateTime end) async {
    if (date.isEmpty) {
      return true;
    } else {
      for (int i = 0; i < date.length; i++) {
        if (start.compareTo(date[i]) < 0 && end.compareTo(date[i]) > 0) {
          return false;
        }
      }
    }
    return true;
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate =
          DateFormat('dd/MM/yyyy').format(args.value.startDate).toString();
      _endDate = DateFormat('dd/MM/yyyy')
          .format(args.value.endDate ?? args.value.startDate)
          .toString();
    });
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/car_parameter.dart';
import '../leastbutton.dart';
import 'buttom_widget.dart';

class DateRangePickerWidget extends StatefulWidget {
  const DateRangePickerWidget({Key? key}) : super(key: key);

  @override
  _DateRangePickerWidgetState createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  DateTimeRange? dateRange;

  String getFrom() {
    if (dateRange == null) {
      return 'From';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateRange!.start);
    }
  }

  String getUntil() {
    if (dateRange == null) {
      return 'Until';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateRange!.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
        title: 'Date Range',
        child: Column(children: [
          Row(children: [
            Expanded(
                child: ButtonWidget(
                    text: getFrom(), onClicked: () => pickDateRange(context))),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Colors.black),
            const SizedBox(width: 8),
            Expanded(
                child: ButtonWidget(
                    text: getUntil(), onClicked: () => pickDateRange(context)))
          ]),
          LeastButton(
              value: SearchCar.date1Search.toString() +
                  ' => ' +
                  SearchCar.date2Search.toString())
        ]));
  }

  Future pickDateRange(BuildContext context) async {
    final newDateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDateRange: dateRange);
    if (newDateRange == null) return;
    setState(() => dateRange = newDateRange);
    SearchCar.date1Search = DateFormat('dd-MM-yyyy').format(dateRange!.start);
    SearchCar.date2Search = DateFormat('dd-MM-yyyy').format(dateRange!.end);
  }
}

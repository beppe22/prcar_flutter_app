import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../leastbutton.dart';
import 'buttom_widget.dart';

class DateRangePickerWidget extends StatefulWidget {
  const DateRangePickerWidget({Key? key}) : super(key: key);

  @override
  _DateRangePickerWidgetState createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  DateTimeRange? dateRange;
  late DateTime date1, date2;

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
  void initState() {
    super.initState();
    date1 = DateTime.now();
    date2 = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
        title: 'Date Range',
        child: Column(children: [
          Row(children: [
            Expanded(
                child: ButtonWidget(
                    text: getFrom(),
                    onClicked: () => pickDateRange(context).then((data) {
                          setState(() {
                            date1 = data;
                          });
                        }))),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Colors.black),
            const SizedBox(width: 8),
            Expanded(
                child: ButtonWidget(
                    text: getUntil(),
                    onClicked: () => pickDateRange(context).then((data) {
                          setState(() {
                            date2 = data;
                          });
                        })))
          ]),
          LeastButton(
              value: (DateFormat('dd-MM-yyyy ').format(date1) +
                  DateFormat(' dd-MM-yyyy').format(date2)))
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
  }
}

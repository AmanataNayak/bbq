import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Filter extends StatefulWidget {
  const Filter({Key key}) : super(key: key);

  @override
  State<Filter> createState() => FilterState();
}

class FilterState extends State<Filter> {
  DateTime dateTimeStart;
  DateFormat formatterStart;
  String formattedStart;

  DateTime dateTimeEnd;
  DateFormat formatterEnd;
  String formattedEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          ElevatedButton.icon(
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: dateTimeStart == null
                          ? DateTime.now()
                          : dateTimeStart,
                      firstDate: DateTime(2001),
                      lastDate: DateTime(2029))
                  .then((date) {
                setState(() {
                  dateTimeStart = date;
                  formatterStart = DateFormat('yyyy-MM-dd');
                  formattedStart = formatterStart.format(dateTimeStart);
                });
              });
            },
            icon: Icon(
              Icons.calendar_today_outlined,
              color: Colors.white,
            ),
            label: Text(
                dateTimeStart == null ? 'Pick start date' : formattedStart),
          ),
          SizedBox(
            width: 10,
          ),
          ElevatedButton.icon(
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate:
                          dateTimeEnd == null ? DateTime.now() : dateTimeEnd,
                      firstDate: DateTime(2001),
                      lastDate: DateTime(2029))
                  .then((date) {
                dateTimeEnd = date;
                formatterEnd = DateFormat('yyyy-MM-dd');
                setState(() {
                  formattedEnd = formatterEnd.format(dateTimeEnd);
                });
              });
            },
            label: Text(dateTimeEnd == null ? 'Pick end date' : formattedEnd),
            icon: Icon(
              Icons.calendar_today_outlined,
              color: Colors.white,
            ),
          ),
        ]),
      ),
    );
  }
}

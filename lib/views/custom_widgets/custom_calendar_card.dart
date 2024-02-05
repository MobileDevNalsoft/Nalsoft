import 'package:flutter/material.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CustomCalendarCard extends StatelessWidget {
  DateTime now = DateTime.now();

  // used to work with the selected dates in SfDateRangePicker
  DateRangePickerController? controller = DateRangePickerController();
  bool Function(DateTime) selectibleDayPredicate;
  bool forAdmin;
  DateRangePickerSelectionMode selectionMode;
  dynamic Function(Object?)? onSubmit;
  void Function()? onCancel;
  String confirmText;
  String cancelText;
  void Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged;

  CustomCalendarCard(
      {super.key,
      required this.forAdmin,
      this.controller,
      this.onSelectionChanged,
      required this.selectibleDayPredicate,
      required this.selectionMode,
      required this.onSubmit,
      required this.onCancel,
      required this.confirmText,
      required this.cancelText});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.95,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 18.0, top: 4),
              child: Text('Lunch Calendar'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 18),
              child: Text(
                '${DateFormat('EEEE').format(now).substring(0, 3)}, ${DateFormat('MMMM').format(now).substring(0, 3)} ${now.day}',
                style: const TextStyle(fontSize: 30),
              ),
            ),
            const Divider(),
            Consumer<UserDataProvider>(

              builder: (context, provider, child) {
                return SfDateRangePicker(
                  controller: controller,
                  minDate: DateTime(now.year, 1, 1, 0, 0, 0, 0, 0),
                  maxDate: DateTime(now.year, 12, 31, 23, 59, 0, 0, 0),
                  selectionColor: Colors.deepPurple.shade100,
                  selectableDayPredicate: selectibleDayPredicate,
                  cellBuilder: (BuildContext context,
                      DateRangePickerCellDetails details) {
                    Color circleColor;

                    if (!forAdmin) {
                      circleColor = provider.getOpted.any((element) => element.date==details.date.toString().substring(0, 10))
                          ? Colors.green.shade200
                          : provider.getNotOpted.map((e) => e.date).toList().contains(
                                  details.date.toString().substring(0, 10))
                              ? Colors.orange.shade200
                              : provider.holidays.contains(
                                      details.date.toString().substring(0, 10))
                                  ? Colors.red.shade100
                                  : (details.date.weekday == DateTime.sunday ||
                                          details.date.weekday ==
                                              DateTime.saturday)
                                      ? Colors.blueGrey.shade200
                                      : ((details.date.day == now.day &&
                                                  details.date.month <=
                                                      now.month &&
                                                  now.hour >= 15 &&
                                                  !provider.getOpted.contains(
                                                      details.date
                                                          .toString()
                                                          .substring(0, 10)) &&
                                                  !provider
                                                      .getNotOpted.map((e) => e.date).toList()
                                                      .contains(details.date.toString().substring(0, 10))) ||
                                              ((details.date.day < now.day && details.date.month <= now.month) && !provider.getOpted.contains(details.date.toString().substring(0, 10)) && !provider.getNotOpted.map((e) => e.date).toList().contains(details.date.toString().substring(0, 10))))
                                          ? Colors.grey.shade300
                                          : Colors.white30;
                    } else {
                      circleColor = provider.holidays.contains(
                              details.date.toString().substring(0, 10))
                          ? Colors.red.shade100
                          : (details.date.weekday == DateTime.sunday ||
                                  details.date.weekday == DateTime.saturday)
                              ? Colors.blueGrey.shade200
                              : Colors.white30;
                    }

                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        width: details.bounds.width / 2,
                        height: details.bounds.width / 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: circleColor,
                        ),
                        child: Center(child: Text(details.date.day.toString())),
                      ),
                    );
                  },
                  allowViewNavigation: false,
                  showActionButtons: true,
                  selectionMode: selectionMode,
                  showNavigationArrow: true,
                  onSubmit: onSubmit,
                  onCancel: onCancel,
                  confirmText: confirmText,
                  cancelText: cancelText,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

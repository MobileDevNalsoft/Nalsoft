import "package:flutter/material.dart";
import "package:intl/intl.dart";
import 'package:meals_management/providers/home_status_provider.dart';
import "package:meals_management/providers/user_data_provider.dart";
import "package:meals_management/views/custom_widgets/custom_button.dart";
import "package:meals_management/views/custom_widgets/custom_snackbar.dart";
import "package:provider/provider.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";

// ignore: must_be_immutable
class UpdateLunchStatus extends StatelessWidget {
  UpdateLunchStatus({super.key});

  DateRangePickerController datesController = DateRangePickerController();

  TextEditingController notOptController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var now = DateTime.now();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          // title: const Text("Lunch Status"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.account_circle_sharp))
          ],
          backgroundColor: const Color.fromARGB(100, 179, 110, 234),
          elevation: 4,
          toolbarHeight: 65,
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: size.height * 0.01,
            ),
            const Text(
              'Select Category :',
              style: TextStyle(fontSize: 13),
            ),
            DropdownButton<String>(
              value: Provider.of<HomeStatusProvider>(context, listen: true)
                  .getReason,
              onChanged: (String? newValue) {
                Provider.of<HomeStatusProvider>(context, listen: false)
                    .setReason(newValue!);
              },
              items: <String>['Single day', 'Multiple days']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(
              height: size.height*0.08,
            ),
            SizedBox(
              width: size.width * 0.95,
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                elevation: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0, top: 4),
                      child: Text('Lunch Calendar'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 18),
                      child: Text(
                        '${DateFormat('EEEE').format(now).substring(0, 3)}, ${DateFormat('MMMM').format(now).substring(0, 3)} ${now.day}',
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                    const Divider(),
                    Consumer<UserDataProvider>(
                        builder: (context, provider, child) {
                      return SfDateRangePicker(
                        enablePastDates: false,
                        controller: datesController,
                        // toggleDaySelection: true,

                        selectionColor: Colors.deepPurple.shade200,
                        selectionShape: DateRangePickerSelectionShape.circle,
                        selectableDayPredicate: (date) {
                          return date.weekday != DateTime.saturday &&
                              date.weekday != DateTime.sunday &&
                              ((date.year == now.year &&
                                      date.month == now.month &&
                                      date.day > now.day) ||
                                  (date.year == now.year &&
                                      date.month > now.month)) &&
                              !provider.getHolidays
                                  .contains(date.toString().substring(0, 10));
                        },
                        cellBuilder: (BuildContext context,
                            DateRangePickerCellDetails details) {
                          Color circleColor = provider.getOptedWithURL.keys
                                  .contains(details.date.toString())
                              ? Colors.green.shade200
                              : provider.getNotOptedWithReasons.keys
                                      .contains(details.date.toString())
                                  ? Colors.orange.shade200
                                  : provider.getHolidays.contains(details.date
                                          .toString()
                                          .substring(0, 10))
                                      ? Colors.red.shade100
                                      : (details.date.weekday ==
                                                  DateTime.sunday ||
                                              details.date.weekday ==
                                                  DateTime.saturday)
                                          ? Colors.blueGrey.shade200
                                          : ((details.date.day == now.day &&
                                                      details.date.month <=
                                                          now.month &&
                                                      now.hour >= 15 &&
                                                      !Provider.of<UserDataProvider>(context, listen: false)
                                                          .getOptedWithURL
                                                          .keys
                                                          .contains(
                                                              '${now.toString().substring(0, 10)} 00:00:00.000') &&
                                                      !Provider.of<UserDataProvider>(context, listen: false)
                                                          .getNotOptedWithReasons
                                                          .keys
                                                          .contains('${now.toString().substring(0, 10)} 00:00:00.000')) ||
                                                  (details.date.day < now.day && details.date.month <= now.month) && !Provider.of<UserDataProvider>(context, listen: false).getOptedWithURL.keys.contains('${now.toString().substring(0, 10)} 00:00:00.000') && !Provider.of<UserDataProvider>(context, listen: false).getNotOptedWithReasons.keys.contains('${now.toString().substring(0, 10)} 00:00:00.000'))
                                              ? Colors.grey.shade300
                                              : Colors.white30;
                          return Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              width: details.bounds.width / 2,
                              height: details.bounds.width / 2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: circleColor,
                              ),
                              child: Center(
                                  child: Text(details.date.day.toString())),
                            ),
                          );
                        },
                        
                        showActionButtons: true,
                        allowViewNavigation: true,
                        selectionMode: Provider.of<HomeStatusProvider>(context,
                                        listen: true)
                                    .getReason ==
                                'Multiple days'
                            ? DateRangePickerSelectionMode.multiple
                            : DateRangePickerSelectionMode.single,
                        showNavigationArrow: true,
                        onSubmit: (dates) {
                          print(dates.runtimeType);
                          print(dates);
                          if (Provider.of<HomeStatusProvider>(context,
                                      listen: false)
                                  .getReason ==
                              'Single day') {
                            if (dates.toString().substring(0,10)!=now.toString().substring(0,10)){ 
                              
                              if (DateTime.parse(dates.toString()).weekday ==
                                      DateTime.saturday ||
                                  DateTime.parse(dates.toString()).weekday ==
                                      DateTime.sunday) {
                                CustomSnackBar.showSnackBar(
                                    context, 'remove weekoffs from selection',Colors.red);
                              } else {
                                if (provider.getNotOptedWithReasons.keys
                                    .contains(dates.toString())) {
                                  removeDialog(context, size, dates);
                                } else {
                                  dialog(context, size, dates);
                                }
                              }}
                             else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'You can only update upcoming status',)));
                            }
                           
                          } else if (Provider.of<HomeStatusProvider>(context,
                                      listen: false)
                                  .getReason ==
                              'Multiple days') {
                            List<DateTime> datesList = dates as List<DateTime>;
                            if (datesList.any((element) => provider
                                .getNotOptedWithReasons.keys
                                .contains(element.toString()))) {
                              CustomSnackBar.showSnackBar(context,
                                  'Remove NotOptedDates from selection',Colors.red);
                            } else {
                              dialog(context, size, dates);
                            }
                          }
                        },
                        onCancel: () {
                          datesController.selectedDate = null;
                          datesController.selectedDates = null;
                          datesController.selectedRange = null;
                        },
                      );
                    }),
                    
                  ],
                ),
              ),
            ),
            Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _options(
                                color: Colors.green.shade200,
                                text: const Text(
                                  'Signed',
                                  style: TextStyle(fontSize: 10),
                                )),
                            _options(
                                color: Colors.grey.shade300,
                                text: const Text(
                                  'Not Signed',
                                  style: TextStyle(fontSize: 10),
                                )),
                            _options(
                                color: Colors.orange.shade200,
                                text: const Text(
                                  'Not Opted',
                                  style: TextStyle(fontSize: 10),
                                )),
                            _options(
                                color: Colors.red.shade100,
                                text: const Text(
                                  'Holiday',
                                  style: TextStyle(fontSize: 10),
                                )),
                          ],
                        ),
                      ),
            Image.asset("assets/images/food.png"),
          ],
        ));
  }
  Widget _options({required color, required text}) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: color,
        ),
        text,
      ],
    );
  }

  void dialog(context, size, dates) {
    showDialog(
      context: context,
      builder: (context) {
        notOptController.clear();
        if (notOptController.text.isEmpty) {
          Future.delayed(
            Duration.zero,
            () {
              FocusScope.of(context).requestFocus(_focusNode);
            },
          );
        }
        return AlertDialog(content: Consumer<HomeStatusProvider>(
          builder: (context, dialogProvider, child) {
            return SizedBox(
              width: size.width * 0.6,
              height: size.height * 0.22,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    focusNode: _focusNode,
                    controller: notOptController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'reason for not opting...',
                        hintStyle: const TextStyle(color: Colors.black38),
                        errorText: dialogProvider.getReasonStatusEmpty
                            ? 'reason cannot be empty'
                            : null),
                    maxLines: 2,
                    maxLength: 30,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        dialogProvider.setReasonStatusEmpty(true);
                      } else {
                        dialogProvider.setReasonStatusEmpty(false);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        onPressed: () {
                          Navigator.pop(context);
                          datesController.selectedDate = null;
                          datesController.selectedDates = null;
                          datesController.selectedRange = null;
                        },
                        color: const MaterialStatePropertyAll(Colors.white),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomButton(
                        onPressed: () {
                          if (notOptController.text.isEmpty) {
                            CustomSnackBar.showSnackBar(
                                context, 'reason cannot be empty',Colors.red);
                          } else {
                            if (Provider.of<HomeStatusProvider>(context,
                                        listen: false)
                                    .getReason ==
                                'Single day') {
                              if (DateTime.parse(dates.toString()).weekday ==
                                      DateTime.saturday ||
                                  DateTime.parse(dates.toString()).weekday ==
                                      DateTime.sunday) {
                                CustomSnackBar.showSnackBar(
                                    context, 'remove weekoffs from selection',Colors.red);
                              } else {
                                Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .setNotOptedDatesWithReason(
                                        dates: [dates!],
                                        reason: notOptController.text);
                                Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .pushDate(
                                        date: dates as DateTime,
                                        radioValue: 2,
                                        reason: notOptController.text);
                              }
                            } else {
                              List<DateTime> datesList =
                                  dates as List<DateTime>;
                              if (datesList
                                      .map((e) => e.weekday)
                                      .toList()
                                      .contains(6) ||
                                  datesList
                                      .map((e) => e.weekday)
                                      .toList()
                                      .contains(7)) {
                                CustomSnackBar.showSnackBar(
                                    context, 'remove weekoffs from selection',Colors.red);
                              } else {
                                Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .setNotOptedDatesWithReason(
                                        dates: dates,
                                        reason: notOptController.text);
                                Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .pushDates(
                                        dates: datesList,
                                        radioValue: 2,
                                        reason: notOptController.text);
                              }
                            }
                          }
                          // else{
                          //   PickerDateRange range = dates as PickerDateRange;
                          //   List<DateTime> rangeList = List.generate(int.parse(range.endDate!.toString().substring(8,10))+1 - int.parse(range.startDate!.toString().substring(8,10)), (index) => range.startDate!.add(Duration(days : index)));
                          //   Provider.of<EventsProvider>(context, listen: false).pushDates(dates: rangeList, radioValue: 2, reason: notOptController.text);
                          // }
                          Navigator.pop(context);
                          datesController.selectedDate = null;
                          datesController.selectedDates = null;
                          datesController.selectedRange = null;
                          notOptController.clear();
                        },
                        color: MaterialStatePropertyAll(
                            Colors.deepPurpleAccent.shade200),
                        child: const Text(
                          'Proceed',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ));
      },
    );
  }

  void removeDialog(context, size, dates) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(content: Consumer<HomeStatusProvider>(
          builder: (context, dialogProvider, child) {
            return SizedBox(
              width: size.width * 0.6,
              height: size.height * 0.13,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Do you want to remove this date\nfrom NotOpted ?'),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        onPressed: () {
                          Provider.of<UserDataProvider>(context, listen: false)
                              .removeNotOptedDate(dates);
                          Provider.of<UserDataProvider>(context, listen: false)
                              .removeNotOptedDateFromDB(dates);
                          datesController.selectedDate = null;
                          datesController.selectedDates = null;
                          datesController.selectedRange = null;
                          Navigator.pop(context);
                        },
                        color: const MaterialStatePropertyAll(Colors.white),
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomButton(
                        onPressed: () {
                          Navigator.pop(context);
                          datesController.selectedDate = null;
                          datesController.selectedDates = null;
                          datesController.selectedRange = null;
                        },
                        color: MaterialStatePropertyAll(
                            Colors.deepPurpleAccent.shade200),
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ));
      },
    );
  }
}

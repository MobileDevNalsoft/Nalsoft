import "package:custom_widgets/src.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/intl.dart";
import "package:meals_management/inits/di_container.dart";
import "package:meals_management/models/meals_management/user_events_model.dart";
import "package:meals_management/network_handler_mixin/network_handler.dart";
import 'package:meals_management/providers/meals_management/home_status_provider.dart';
import "package:meals_management/providers/meals_management/user_data_provider.dart";
import "package:meals_management/views/custom_widgets/custom_calendar_card.dart";
import "package:meals_management/views/custom_widgets/custom_legend.dart";
import "package:meals_management/views/in_app_tour.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";
import "package:tutorial_coach_mark/tutorial_coach_mark.dart";
import 'package:dropdown_button2/dropdown_button2.dart';

// ignore: must_be_immutable
class UpdateLunchStatus extends StatefulWidget {
  Function? initData;
  UpdateLunchStatus({this.initData, super.key});

  @override
  State<UpdateLunchStatus> createState() => _UpdateLunchStatusState();
}

class _UpdateLunchStatusState extends State<UpdateLunchStatus>
    with ConnectivityMixin, SingleTickerProviderStateMixin {
  // used to work with the selected dates in SfDateRangePicker
  DateRangePickerController datesController = DateRangePickerController();

  // used to work with the content entered in TextField by user
  TextEditingController notOptController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  final sharedPreferences = sl.get<SharedPreferences>();

  final dropDownKey = GlobalKey();
  final calendarKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;

  void _initAddSiteInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
      targets: addUpdateUpcomingLunchStatusSiteTargets(
          dropDownKey: dropDownKey, calendarKey: calendarKey),
      colorShadow: Colors.black12,
      paddingFocus: 10,
      hideSkip: false,
      opacityShadow: 0.8,
      onFinish: () {
        print('update upcoming lunch status view tutorial completed');
      },
    );
  }

  void _showInAppTour() {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        tutorialCoachMark.show(context: context);
        sharedPreferences.setBool('hasSeenTutorial3', true);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (!sharedPreferences.containsKey('hasSeenTutorial3')) {
      _initAddSiteInAppTour();
      _showInAppTour();
    }
  }

  @override
  void dispose() {
    datesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var now = DateTime.now();

    return SafeArea(
      child: AspectRatio(
        aspectRatio: size.height / size.width,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              title: const Text(
                "Upcoming Status",
                style: TextStyle(fontSize: 18),
              ),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(100, 179, 110, 234),
              elevation: 4,
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Select Category   :     ',
                      style: TextStyle(fontSize: 13),
                    ),
                    Consumer<UserDataProvider>(
                      builder: (context, provider, child) {
                        return DropdownButtonHideUnderline(
                          key: dropDownKey,
                          child: DropdownButton2<String>(
                            onMenuStateChange: (isOpen) {
                              provider.isOpen = isOpen;
                            },
                            isExpanded: true,
                            items: ['Single day', 'Multiple days']
                                .map((String item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            value: Provider.of<HomeStatusProvider>(context,
                                    listen: true)
                                .getReason,
                            onChanged: (String? value) {
                              Provider.of<HomeStatusProvider>(context,
                                      listen: false)
                                  .setReason(value!);
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 35,
                              width: 140,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                                color: Colors.white,
                              ),
                              elevation: 2,
                            ),
                            iconStyleData: IconStyleData(
                              icon: Icon(!provider.isOpen
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_up_rounded),
                              iconSize: 14,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.black,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 150,
                              width: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                              ),
                              offset: const Offset(0, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all<double>(6),
                                thumbVisibility:
                                    MaterialStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 30,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Consumer<UserDataProvider>(
                  key: calendarKey,
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return SizedBox(
                        width: size.width * 0.95,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
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
                                padding:
                                    const EdgeInsets.only(top: 15.0, left: 18),
                                child: Text(
                                  '${DateFormat('EEEE').format(now).substring(0, 3)}, ${DateFormat('MMMM').format(now).substring(0, 3)} ${now.day}',
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                              const Divider(),
                              SizedBox(
                                  height: size.height * 0.37,
                                  child: CustomWidgets.CustomCircularLoader()),
                            ],
                          ),
                        ),
                      );
                    } else if (provider.eventsPresent) {
                      return CustomCalendarCard(
                        isUDP: true,
                        forAdmin: false,
                        controller: datesController,
                        selectionMode: Provider.of<HomeStatusProvider>(context,
                                        listen: true)
                                    .getReason ==
                                'Multiple days'
                            ? DateRangePickerSelectionMode.multiple
                            : DateRangePickerSelectionMode.single,
                        selectibleDayPredicate: (date) {
                          return date.weekday != DateTime.saturday &&
                              date.weekday != DateTime.sunday &&
                              ((date.year == now.year &&
                                      date.month == now.month &&
                                      date.day > now.day) ||
                                  (date.year == now.year &&
                                      date.month > now.month)) &&
                              !Provider.of<UserDataProvider>(context,
                                      listen: false)
                                  .holidays
                                  .contains(date.toString().substring(0, 10)) &&
                              ((date.day > now.day + 1 &&
                                      date.month == now.month) ||
                                  (date.month > now.month) ||
                                  (date.day == now.day + 1 &&
                                      date.month == now.month &&
                                      now.hour < 18));
                        },
                        onSubmit: (dates) {
                          if (Provider.of<HomeStatusProvider>(context,
                                      listen: false)
                                  .getReason ==
                              'Single day') {
                            if (dates.toString().substring(0, 10) !=
                                now.toString().substring(0, 10)) {
                              if (DateTime.parse(dates.toString()).weekday ==
                                      DateTime.saturday ||
                                  DateTime.parse(dates.toString()).weekday ==
                                      DateTime.sunday) {
                                CustomWidgets.CustomSnackBar(
                                    context,
                                    'remove weekoffs from selection',
                                    Colors.red);
                              } else {
                                if (Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .getNotOpted
                                    .map((e) => e.date)
                                    .toList()
                                    .contains(
                                        dates.toString().substring(0, 10))) {
                                  removeDialog(
                                      context, size, [dates as DateTime]);
                                } else {
                                  dialog(context, size, dates);
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Text(
                                'You can only update upcoming status',
                              )));
                            }
                          } else if (Provider.of<HomeStatusProvider>(context,
                                      listen: false)
                                  .getReason ==
                              'Multiple days') {
                            List<DateTime> datesList = dates as List<DateTime>;
                            if (datesList.any((element) =>
                                Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .getNotOpted
                                    .map((e) => e.date)
                                    .toList()
                                    .contains(
                                        element.toString().substring(0, 10)))) {
                              removeDialog(context, size, dates);
                            } else {
                              dialog(context, size, dates);
                            }
                          }
                        },
                        onCancel: () {},
                        confirmText: 'Ok',
                        cancelText: '',
                      );
                    } else {
                      return SizedBox(
                        width: size.width * 0.95,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
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
                                padding:
                                    const EdgeInsets.only(top: 15.0, left: 18),
                                child: Text(
                                  '${DateFormat('EEEE').format(now).substring(0, 3)}, ${DateFormat('MMMM').format(now).substring(0, 3)} ${now.day}',
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                              const Divider(),
                              SizedBox(
                                height: size.height * 0.37,
                                child: Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () {
                                      Provider.of<UserDataProvider>(context,
                                              listen: false)
                                          .setConnected(isConnected());
                                      if (!Provider.of<UserDataProvider>(
                                              context,
                                              listen: false)
                                          .getConnected) {
                                        CustomWidgets.CustomSnackBar(
                                            context,
                                            'No Internet Connection',
                                            Colors.red);
                                      } else {
                                        setState(() {
                                          Provider.of<UserDataProvider>(context,
                                                  listen: false)
                                              .setConnected(isConnected());
                                          widget.initData!();
                                          Provider.of<UserDataProvider>(context,
                                                  listen: false)
                                              .isLoading = true;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
                const CustomLegend(),
                Image.asset("assets/images/food.png"),
              ],
            )),
      ),
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
                      CustomWidgets.CustomElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          datesController.selectedDate = null;
                          datesController.selectedDates = null;
                          datesController.selectedRange = null;
                        },
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomWidgets.CustomElevatedButton(
                        onPressed: () {
                          if (notOptController.text.isEmpty) {
                            CustomWidgets.CustomSnackBar(
                                context, 'reason cannot be empty', Colors.red);
                          } else {
                            if (Provider.of<HomeStatusProvider>(context,
                                        listen: false)
                                    .getReason ==
                                'Single day') {
                              if (DateTime.parse(dates.toString()).weekday ==
                                      DateTime.saturday ||
                                  DateTime.parse(dates.toString()).weekday ==
                                      DateTime.sunday) {
                                CustomWidgets.CustomSnackBar(
                                    context,
                                    'remove weekoffs from selection',
                                    Colors.red);
                              } else {
                                Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .setConnected(isConnected());
                                if (Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .getConnected) {
                                  Provider.of<UserDataProvider>(context,
                                          listen: false)
                                      .updateUserEvents([
                                    Dates(
                                            date: dates
                                                .toString()
                                                .substring(0, 10),
                                            info: notOptController.text)
                                        .toJson()
                                  ], false, null);
                                } else {
                                  CustomWidgets.CustomSnackBar(
                                      context, "No internet", Colors.red);
                                }
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
                                CustomWidgets.CustomSnackBar(
                                    context,
                                    'remove weekoffs from selection',
                                    Colors.red);
                              } else {
                                Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .setConnected(isConnected());
                                if (Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .getConnected) {
                                  Provider.of<UserDataProvider>(context,
                                          listen: false)
                                      .updateUserEvents(
                                          dates
                                              .map((date) => Dates(
                                                      date: date
                                                          .toString()
                                                          .substring(0, 10),
                                                      info:
                                                          notOptController.text)
                                                  .toJson())
                                              .toList(),
                                          false,
                                          null);
                                } else {
                                  CustomWidgets.CustomSnackBar(
                                      context, "No internet", Colors.red);
                                }
                              }
                            }
                          }
                          Navigator.pop(context);
                          datesController.selectedDate = null;
                          datesController.selectedDates = null;
                          datesController.selectedRange = null;
                          notOptController.clear();
                        },
                        backgroundColor: MaterialStatePropertyAll(
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

  void removeDialog(context, size, List<DateTime> dates) {
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
                  const Text('Do you want to remove from \nNotOpted ?'),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomWidgets.CustomElevatedButton(
                        onPressed: () {
                          Provider.of<UserDataProvider>(context, listen: false)
                              .setConnected(isConnected());
                          if (Provider.of<UserDataProvider>(context,
                                  listen: false)
                              .getConnected) {
                            Provider.of<UserDataProvider>(context,
                                    listen: false)
                                .deleteUserEvents(dates
                                    .map((e) =>
                                        {"date": e.toString().substring(0, 10)})
                                    .toList());
                          } else {
                            CustomWidgets.CustomSnackBar(
                                context, "No internet", Colors.red);
                          }

                          datesController.selectedDate = null;
                          datesController.selectedDates = null;
                          datesController.selectedRange = null;
                          Navigator.pop(context);
                        },
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomWidgets.CustomElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          datesController.selectedDate = null;
                          datesController.selectedDates = null;
                          datesController.selectedRange = null;
                        },
                        backgroundColor: MaterialStatePropertyAll(
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

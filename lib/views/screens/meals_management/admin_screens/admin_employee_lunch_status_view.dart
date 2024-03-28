import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_email_sender/flutter_email_sender.dart";
import "package:intl/intl.dart";
import "package:meals_management/inits/di_container.dart";
import "package:meals_management/network_handler_mixin/network_handler.dart";
import "package:meals_management/providers/meals_management/admin_employees_provider.dart";
import "package:meals_management/providers/meals_management/home_status_provider.dart";
import "package:meals_management/providers/meals_management/user_data_provider.dart";
import "package:meals_management/views/custom_widgets/custom_calendar_card.dart";
import "package:meals_management/views/custom_widgets/custom_legend.dart";
import "package:meals_management/views/in_app_tour.dart";
import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";
import "package:syncfusion_flutter_xlsio/xlsio.dart" as excel;
import 'package:custom_widgets/src.dart';
import "package:tutorial_coach_mark/tutorial_coach_mark.dart";

// ignore: must_be_immutable
class EmployeeLunchStatus extends StatefulWidget {
  String? userName;
  String? empID;
  EmployeeLunchStatus({this.userName, this.empID, super.key});
  @override
  State<EmployeeLunchStatus> createState() => _EmployeeLunchStatusState();
}

class _EmployeeLunchStatusState extends State<EmployeeLunchStatus>
    with ConnectivityMixin {
  // used to work with the selected dates in SfDateRangePicker
  DateRangePickerController datesController = DateRangePickerController();

  bool _isLoading = true;
  bool isDataPresent = false;

  final sharedPreferences = sl.get<SharedPreferences>();

  final calendarKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;

  void _initAddSiteInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
      targets: addEmployeeLunchStatusSiteTargets(
        calendarKey: calendarKey,
      ),
      colorShadow: Colors.black12,
      paddingFocus: 10,
      hideSkip: false,
      opacityShadow: 0.8,
      onFinish: () {
        print('employee lunch status tutorial completed');
      },
    );
  }

  void _showInAppTour() {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        tutorialCoachMark.show(context: context);
        sharedPreferences.setBool('hasSeenTutorial6', true);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    intiData();
  }

  @override
  void dispose() {
    datesController.dispose();
    super.dispose();
  }

  Future<void> intiData() async {
    Provider.of<AdminEmployeesProvider>(context, listen: false)
        .isAdminEmployeeDataPresent = false;
    try {
      await Provider.of<AdminEmployeesProvider>(context, listen: false)
          .getUserinfo(widget.userName);
      // ignore: use_build_context_synchronously
      await Provider.of<AdminEmployeesProvider>(context, listen: false)
          .getUserEventsData(empID: widget.empID);
    } finally {
      setState(() {
        _isLoading = false;
        if (!sharedPreferences.containsKey('hasSeenTutorial6')) {
          _initAddSiteInAppTour();
          _showInAppTour();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    DateTime now = DateTime.now();

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
            "Lunch Status",
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
          actions: const [
            Icon(
              Icons.account_circle_sharp,
              size: 30,
            ),
            SizedBox(
              width: 10,
            )
          ],
          backgroundColor: const Color.fromARGB(100, 179, 110, 234),
          elevation: 4,
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
        ),
        body: _isLoading
            ? CustomWidgets.CustomCircularLoader()
            : Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Employee name",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),
                                Text(
                                  "Department",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),
                              ],
                            ),
                            const Column(
                              children: [Text(" : "), Text(" : ")],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.height * 0.025,
                                  width: size.width * 0.45,
                                  child: Text(
                                      Provider.of<AdminEmployeesProvider>(
                                                  context,
                                                  listen: true)
                                              .isAdminEmployeeDataPresent
                                          ? Provider.of<AdminEmployeesProvider>(
                                                  context,
                                                  listen: false)
                                              .getUserData
                                              .data!
                                              .empName!
                                          : '',
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis)),
                                ),
                                SizedBox(
                                  height: size.height * 0.025,
                                  width: size.width * 0.45,
                                  child: Text(
                                      Provider.of<AdminEmployeesProvider>(
                                                  context,
                                                  listen: true)
                                              .isAdminEmployeeDataPresent
                                          ? Provider.of<AdminEmployeesProvider>(
                                                  context,
                                                  listen: false)
                                              .getUserData
                                              .data!
                                              .department!
                                          : '',
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Consumer<AdminEmployeesProvider>(
                        key: calendarKey,
                        builder: (context, provider, child) {
                          if (provider.isLoading && isConnected()) {
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
                                      padding:
                                          EdgeInsets.only(left: 18.0, top: 4),
                                      child: Text('Lunch Calendar'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15.0, left: 18),
                                      child: Text(
                                        '${DateFormat('EEEE').format(now).substring(0, 3)}, ${DateFormat('MMMM').format(now).substring(0, 3)} ${now.day}',
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                    ),
                                    const Divider(),
                                    SizedBox(
                                        height: size.height * 0.37,
                                        child: CustomWidgets
                                            .CustomCircularLoader()),
                                  ],
                                ),
                              ),
                            );
                          } else if (!Provider.of<AdminEmployeesProvider>(
                                  context,
                                  listen: false)
                              .isAdminEmployeeDataPresent) {
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
                                      padding:
                                          EdgeInsets.only(left: 18.0, top: 4),
                                      child: Text('Lunch Calendar'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15.0, left: 18),
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
                                            Provider.of<UserDataProvider>(
                                                    context,
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
                                                Provider.of<UserDataProvider>(
                                                        context,
                                                        listen: false)
                                                    .setConnected(
                                                        isConnected());
                                                intiData();
                                                Provider.of<AdminEmployeesProvider>(
                                                        context,
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
                          } else {
                            return CustomCalendarCard(
                              isUDP: false,
                              forAdmin: false,
                              selectionMode:
                                  DateRangePickerSelectionMode.single,
                              selectibleDayPredicate: (date) {
                                if (date.isAfter(DateTime.now()
                                    ) || date.toString().substring(0,10)== now.toString().substring(0,10)) {
                                  return true;
                                }
                                return false;
                              },
                              onSubmit: (date) {
                              
                                if (Provider.of<AdminEmployeesProvider>(context,
                                        listen: false)
                                    .getNotOpted
                                    .map((e) => e.date)
                                    .toList()
                                    .contains(
                                        date.toString().substring(0, 10))) {
                                  removeDialog(
                                      context, size, [date as DateTime]);
                                } 
                              },
                              onCancel: () {
                                      isConnected()
                                  ? sendMail(context)
                                  : CustomWidgets.CustomSnackBar(
                                      context, "No internet", Colors.red);
                              },
                              confirmText: 'Update',
                              cancelText: 'Send',

                            );
                          }
                        },
                      ),
                      const CustomLegend(),
                      Image.asset("assets/images/food.png"),
                    ],
                  ),
                  if (Provider.of<AdminEmployeesProvider>(context, listen: true)
                      .isMailLoading)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                          color: Colors.black38,
                          child: CustomWidgets.CustomCircularLoader()),
                    ),
                ],
              ),
      ),
    ));
  }


  Future<void> sendMail(BuildContext context) async {
    Provider.of<AdminEmployeesProvider>(context, listen: false).isMailLoading =
        true;

    final dir = await getTemporaryDirectory();

    DateTime now = DateTime.now();

    //   // Create a new Excel workbook
    final excel.Workbook workbook = excel.Workbook();

    //   // Add a worksheet to the workbook
    final excel.Worksheet sheet = workbook.worksheets[0];

    excel.Style style = workbook.styles.add('style');

    style.wrapText = true;

    //   // Set the worksheet name
    sheet.name =
        // ignore: use_build_context_synchronously
        '${Provider.of<AdminEmployeesProvider>(context, listen: false).getUserData.data!.empName}'
        's Meals data';

    //   // Append headers
    sheet.getRangeByIndex(1, 1).setText(
        // ignore: use_build_context_synchronously
        '${Provider.of<AdminEmployeesProvider>(context, listen: false).getUserData.data!.userName}(${Provider.of<AdminEmployeesProvider>(context, listen: false).getUserData.data!.empId})');

    sheet.getRangeByIndex(3, 1).setText('Date');
    sheet.getRangeByIndex(3, 2).setText('Status');
    sheet.getRangeByIndex(3, 3).setText('Info');
    sheet.getRangeByIndex(3, 1).builtInStyle = excel.BuiltInStyles.heading4;
    sheet.getRangeByIndex(3, 2).builtInStyle = excel.BuiltInStyles.heading4;
    sheet.getRangeByIndex(3, 3).builtInStyle = excel.BuiltInStyles.heading4;

    List<DateTime> rangeDates = List.generate(
        now.difference(DateTime(now.year, now.month, 1)).inDays + 1,
        (index) => DateTime(now.year, now.month, 1).add(Duration(days: index)));

    int rowIndex = 4;

    for (var date in rangeDates) {
      // ignore: use_build_context_synchronously
      if (Provider.of<AdminEmployeesProvider>(context, listen: false)
          .getOpted
          .any((element) => date.toString().substring(0, 10) == element.date)) {
        sheet
            .getRangeByIndex(rowIndex, 1)
            .setText(date.toString().substring(0, 10));
        sheet.getRangeByIndex(rowIndex, 2).setText('Opted');
        // ignore: use_build_context_synchronously
        Provider.of<AdminEmployeesProvider>(context, listen: false)
            .getOpted
            .where(
                (element) => date.toString().substring(0, 10) == element.date)
            .first
            .info = DateTime.fromMillisecondsSinceEpoch(int.parse(
                // ignore: use_build_context_synchronously
                Provider.of<AdminEmployeesProvider>(context, listen: false)
                    .getOpted
                    .where((element) =>
                        date.toString().substring(0, 10) == element.date)
                    .first
                    .info!))
            .toString()
            .substring(11, 19);
        sheet.getRangeByIndex(rowIndex, 3).setText(
            // ignore: use_build_context_synchronously
            Provider.of<AdminEmployeesProvider>(context, listen: false)
                .getOpted
                .where((element) =>
                    date.toString().substring(0, 10) == element.date)
                .first
                .info);
        rowIndex++;
        // ignore: use_build_context_synchronously
      } else if (Provider.of<AdminEmployeesProvider>(context, listen: false)
          .getNotOpted
          .any((element) => date.toString().substring(0, 10) == element.date)) {
        sheet
            .getRangeByIndex(rowIndex, 1)
            .setText(date.toString().substring(0, 10));
        sheet.getRangeByIndex(rowIndex, 2).setText('NotOpted');
        sheet.getRangeByIndex(rowIndex, 3).setText(
            // ignore: use_build_context_synchronously
            Provider.of<AdminEmployeesProvider>(context, listen: false)
                .getNotOpted
                .where((element) =>
                    date.toString().substring(0, 10) == element.date)
                .first
                .info);
        rowIndex++;
      } else if (date.day < now.day && date.month <= now.month) {
        sheet
            .getRangeByIndex(rowIndex, 1)
            .setText(date.toString().substring(0, 10));
        sheet.getRangeByIndex(rowIndex, 2).setText('No Status');
        rowIndex++;
      }
    }

    // ignore: use_build_context_synchronously
    for (var date in Provider.of<AdminEmployeesProvider>(context, listen: false)
        .getNotOpted) {
      if ((DateTime.parse(date.date!).day > now.day &&
              DateTime.parse(date.date!).month == now.month) ||
          DateTime.parse(date.date!).month > now.month) {
        sheet.getRangeByIndex(rowIndex, 1).setText(date.date!);
        sheet.getRangeByIndex(rowIndex, 2).setText('NotOpted');
        sheet.getRangeByIndex(rowIndex, 3).setText(date.info);
        rowIndex++;
      }
    }

    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);
    sheet.autoFitColumn(3);

    try {
      // Save the workbook to external storage
      final List<int> bytes = workbook.saveAsStream();

      final path =
          // ignore: use_build_context_synchronously
          '${dir.path}/${Provider.of<AdminEmployeesProvider>(context, listen: false).getUserData.data!.empName}_mess_data_${DateTime.now().toString().substring(0, 10)}.xlsx';
      final File file = File(path);
      await file.writeAsBytes(bytes);

      // Check email permissions
      var status = await Permission.storage.status;
      if (status.isDenied) {
        await Permission.storage.request();
      }

      // Permission granted, proceed with sending email
      const recipientEmail = 'chiluverimadhankumarnetha@gmail.com';
      const subject = 'Excel Data';
      const body = 'Please find the attached Excel file with the data.';

      final email = Email(
        body: body,
        subject: subject,
        recipients: [recipientEmail],
        attachmentPaths: [path],
      );
      // ignore: use_build_context_synchronously
      Provider.of<AdminEmployeesProvider>(context, listen: false)
          .isMailLoading = false;
      //     // Send email
      await FlutterEmailSender.send(email);
    } catch (error) {
      // Handle the error
      print('Error sending email: $error');
    }
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
                        if( isConnected()) {
                            Provider.of<AdminEmployeesProvider>(context,
                                    listen: false)
                                .deleteUserEvents(Provider.of<AdminEmployeesProvider>(context,
                                    listen: false).getUserData.data!.empId!,dates
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


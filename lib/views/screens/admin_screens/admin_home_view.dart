import "dart:io";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:get_it/get_it.dart";
import "package:meals_management/views/custom_widgets/custom_button.dart";
import "package:meals_management/views/custom_widgets/custom_calendar_card.dart";
import "package:meals_management/views/screens/admin_screens/admin_employees_view.dart";
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import "package:flutter/material.dart";
import "package:flutter_email_sender/flutter_email_sender.dart";
import "package:intl/intl.dart";
import "package:meals_management/providers/admin_employees_provider.dart";
import "package:meals_management/providers/user_data_provider.dart";
import "package:meals_management/route_management/route_management.dart";
import "package:meals_management/views/custom_widgets/custom_snackbar.dart";
import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";
import '../../../providers/home_status_provider.dart';
import '../../../repositories/auth_repo.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  DateTime now = DateTime.now();

  late SharedPreferences sharedPreferences;

  String qrResult = '';

  @override
  void initState() {
    super.initState();
    sharedPreferences = GetIt.instance.get<SharedPreferences>();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    DateRangePickerController datesController = DateRangePickerController();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: size.height * 0.13,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(100, 179, 110, 234),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      )),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Consumer<HomeStatusProvider>(
                        builder: (context, provider, child) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 25, top: 15),
                            child: Text(
                              'Hi,\n${Provider.of<UserDataProvider>(context, listen: false).getUsername}',
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                      const Expanded(child: SizedBox()),
                      Consumer<HomeStatusProvider>(
                        builder: (context, provider, child) {
                          return Provider.of<UserDataProvider>(context,
                                      listen: false)
                                  .getIsAdmin=="A"
                              ? Switch(
                                  value: true,
                                  onChanged: (value) {
                                    Navigator.pushReplacementNamed(context,
                                        RouteManagement.employeeHomePage);
                                  },
                                  activeColor:
                                      const Color.fromARGB(255, 181, 129, 248),
                                )
                              : const SizedBox();
                        },
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: PopupMenuButton(
                      //     itemBuilder: (BuildContext context) {
                      //       return [
                      //         PopupMenuItem(
                      //             value: 'Sign Out',
                      //             height: 10,
                      //             onTap: () => AthRepo()
                      //                     .signOutNow()
                      //                     .then((value) {
                      //                   sharedPreferences.setString(
                      //                       "islogged", 'false');
                      //                   Navigator.pushNamedAndRemoveUntil(
                      //                       context,
                      //                       RouteManagement.loginPage,
                      //                       (route) => false);
                      //                 }),
                      //             child: const Text('Sign Out'))
                      //       ];
                      //     },
                      //     child: const Icon(Icons.power_settings_new_sharp),
                      //   ),
                      // )
                    
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color.fromRGBO(236, 230, 240, 100),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    EmployeeSearch(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.groups),
                          SizedBox(
                            width: size.width * 0.04,
                          ),
                          const Expanded(
                              child: Text("Search employee",
                                  style: TextStyle(
                                      color: Color.fromRGBO(73, 69, 79, 100)))),
                          const Icon(Icons.search),
                        ],
                      ),
                    ),
                  ),
                ),
                const Text("Select Date",
                    style: TextStyle(color: Color.fromRGBO(73, 69, 79, 100))),
                CustomCalendarCard(
                  forAdmin: true,
                  controller: datesController,
                  selectionMode: DateRangePickerSelectionMode.single,
                  selectibleDayPredicate: (date) {
                    return date.weekday != DateTime.saturday &&
                        date.weekday != DateTime.sunday &&
                        date.day <= now.day &&
                        date.month <= now.month &&
                        !Provider.of<UserDataProvider>(context, listen: false)
                            .getHolidays
                            .contains(date.toString().substring(0, 10));
                  },
                  onSubmit: (date) {
                    if (date != null) {
                      date = date as DateTime;
                      sendMail(date, context);
                    } else {
                      CustomSnackBar.showSnackBar(
                          context, 'please select a date', Colors.red);
                    }
                  },
                  onCancel: () {
                    datesController.selectedDate = null;
                    datesController.selectedDates = null;
                  },
                  confirmText: 'Send Mail',
                  cancelText: 'Clear Selection',
                ),
                CustomButton(
                    color: MaterialStatePropertyAll(Colors.blue),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RouteManagement.generateNotification);
                    },
                    child: const Text("Notify",
                        style: TextStyle(color: Colors.white))),
                Image.asset("assets/images/food.png")
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
                  child: const SpinKitCircle(
                    color: Color.fromARGB(255, 185, 147, 255),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> sendMail(DateTime date, BuildContext context) async {
    Provider.of<AdminEmployeesProvider>(context, listen: false).isMailLoading =
        true;
    await Provider.of<AdminEmployeesProvider>(context, listen: false)
        .setAllEmpData();
    List<Map<String, dynamic>> empData =
        Provider.of<AdminEmployeesProvider>(context, listen: false)
            .getAllEmpData;

    final dir = await getExternalStorageDirectory();

    // Create a new Excel workbook
    final excel.Workbook workbook = excel.Workbook();

    // Add a worksheet to the workbook
    final excel.Worksheet sheet = workbook.worksheets[0];

    excel.Style style = workbook.styles.add('style');

    style.wrapText = true;

    // Set the worksheet name
    sheet.name = 'Today\'s Meals opted employees';

    // Append headers
    sheet.getRangeByIndex(1, 1).setText('Employee ID');
    sheet.getRangeByIndex(1, 2).setText('Employee Name');
    sheet.getRangeByIndex(1, 3).setText(date.toString().substring(0, 10));
    sheet.getRangeByIndex(1, 4).setText('Reason');

    // Append data
    int rowIndex = 2;
    for (var data in empData) {
      if (data['opted'].contains(date.toString().substring(0, 10))) {
        sheet.getRangeByIndex(rowIndex, 1).setText(data['employee_id']);
        sheet.getRangeByIndex(rowIndex, 2).setText(data['username']);
        sheet.getRangeByIndex(rowIndex, 3).setText('Opted');
      } else if (data['notOpted']
          .keys
          .contains(date.toString().substring(0, 10))) {
        sheet.getRangeByIndex(rowIndex, 1).setText(data['employee_id']);
        sheet.getRangeByIndex(rowIndex, 2).setText(data['username']);
        sheet.getRangeByIndex(rowIndex, 3).setText('Not Opted');
        sheet
            .getRangeByIndex(rowIndex, 4)
            .setText(data['notOpted'][date.toString().substring(0, 10)]);
      } else {
        sheet.getRangeByIndex(rowIndex, 1).setText(data['employee_id']);
        sheet.getRangeByIndex(rowIndex, 2).setText(data['username']);
        sheet.getRangeByIndex(rowIndex, 3).setText('No Status');
      }
      rowIndex++;
    }

    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);
    sheet.autoFitColumn(3);

    try {
      // Save the workbook to external storage
      final List<int> bytes = workbook.saveAsStream();

      final path = '${dir!.path}/mess_data_$now.xlsx';
      final File file = File(path);
      await file.writeAsBytes(bytes);

      // Print debug information
      print('File saved at: $path');

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
      Provider.of<AdminEmployeesProvider>(context, listen: false)
          .isMailLoading = false;

      // Send email
      await FlutterEmailSender.send(email);
    } catch (error) {
      // Handle the error
      print('Error sending email: $error');
    }
  }
}

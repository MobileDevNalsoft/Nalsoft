import "dart:io";
import "package:flutter_spinkit/flutter_spinkit.dart";
import 'package:http/http.dart' as http;
import "package:flutter/material.dart";
import "package:flutter_email_sender/flutter_email_sender.dart";
import "package:meals_management/models/user_model.dart";
import "package:meals_management/providers/admin_employees_provider.dart";
import "package:meals_management/providers/user_data_provider.dart";
import "package:meals_management/utils/constants.dart";
import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";
import "package:syncfusion_flutter_xlsio/xlsio.dart" as excel;

class EmployeeLunchStatus extends StatefulWidget {
  String? empid;
  EmployeeLunchStatus({super.key, this.empid});

  @override
  State<EmployeeLunchStatus> createState() => _EmployeeLunchStatusState();
}

class _EmployeeLunchStatusState extends State<EmployeeLunchStatus> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    try {
      String empid = widget.empid!;
      await Provider.of<AdminEmployeesProvider>(context, listen: false).setEmpDataWithID(empid: empid);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    DateTime now = DateTime.now();

    return SafeArea(
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
        actions: [
          Icon(
            Icons.account_circle_sharp,
            size: 30,
          ),
          SizedBox(
            width: 10,
          )
        ],
        backgroundColor: const Color.fromRGBO(236, 230, 240, 100),
        elevation: 4,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitCircle(
                  color: Color.fromARGB(255, 179, 157, 219), size: 50.0),
            )
          : Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
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
                              Text(
                                "Floor",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16),
                              )
                            ],
                          ),
                          Column(
                            children: [Text(":"), Text(":"), Text(":")],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  Provider.of<AdminEmployeesProvider>(context,
                                          listen: false)
                                      .getEmpWithID!
                                      .userName,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  Provider.of<AdminEmployeesProvider>(context,
                                          listen: false)
                                      .getEmpWithID!
                                      .department,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  Provider.of<AdminEmployeesProvider>(context,
                                          listen: false)
                                      .getEmpWithID!
                                      .floor,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    SizedBox(
                      height: size.height * 0.45,
                      width: size.width * 0.95,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        elevation: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SfDateRangePicker(
                                minDate:
                                    DateTime(now.year, 1, 1, 0, 0, 0, 0, 0),
                                maxDate:
                                    DateTime(now.year, 12, 31, 23, 59, 0, 0, 0),
                                selectionColor: Colors.deepPurple.shade100,
                                selectionShape:
                                    DateRangePickerSelectionShape.circle,
                                showActionButtons: true,
                                selectableDayPredicate: (date) {
                                  return Provider.of<UserDataProvider>(context,
                                          listen: false)
                                      .getNotOptedWithReasons
                                      .keys
                                      .contains(date.toString());
                                },
                                cellBuilder: (BuildContext context,
                                    DateRangePickerCellDetails details) {
                                  Color circleColor = Provider.of<AdminEmployeesProvider>(
                                              context,
                                              listen: false)
                                          .getEmpWithID!
                                          .opted
                                          .contains(details.date
                                              .toString()
                                              .substring(0, 10))
                                      ? Colors.green.shade200
                                      : Provider.of<AdminEmployeesProvider>(context, listen: false)
                                              .getEmpWithID!
                                              .notOpted
                                              .keys
                                              .contains(details.date
                                                  .toString()
                                                  .substring(0, 10))
                                          ? Colors.orange.shade200
                                          : Provider.of<UserDataProvider>(context,
                                                      listen: false)
                                                  .getHolidays
                                                  .contains(details.date.toString().substring(0, 10))
                                              ? Colors.red.shade100
                                              : (details.date.weekday == DateTime.sunday || details.date.weekday == DateTime.saturday)
                                                  ? Colors.blueGrey.shade200
                                                  : ((details.date.day == now.day && details.date.month <= now.month && now.hour >= 15 && !Provider.of<AdminEmployeesProvider>(context, listen: false).getEmpWithID!.opted.contains(details.date.toString().substring(0, 10)) && !Provider.of<AdminEmployeesProvider>(context, listen: false).getEmpWithID!.notOpted.keys.contains(details.date.toString().substring(0, 10))) || ((details.date.day < now.day && details.date.month <= now.month) && !Provider.of<AdminEmployeesProvider>(context, listen: false).getEmpWithID!.opted.contains(details.date.toString().substring(0, 10)) && !Provider.of<AdminEmployeesProvider>(context, listen: false).getEmpWithID!.notOpted.keys.contains(details.date.toString().substring(0, 10))))
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
                                            child: Text(
                                                details.date.day.toString())),
                                      ));
                                },
                                allowViewNavigation: true,
                                selectionMode:
                                    DateRangePickerSelectionMode.single,
                                showNavigationArrow: true,
                                // this will not be required when we integrate local api to app
                                onSelectionChanged:
                                    (dateRangePickerSelectionChangedArgs) {
                                  if (Provider.of<AdminEmployeesProvider>(
                                          context,
                                          listen: false)
                                      .getEmpWithID!
                                      .notOpted
                                      .keys
                                      .contains(
                                          dateRangePickerSelectionChangedArgs
                                              .value
                                              .toString())) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: SizedBox(
                                              width: size.width * 0.6,
                                              height: size.height * 0.08,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Reason',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  SizedBox(
                                                    height: size.height * 0.02,
                                                  ),
                                                  Text(Provider.of<
                                                                  AdminEmployeesProvider>(
                                                              context,
                                                              listen: false)
                                                          .getEmpWithID!
                                                          .notOpted[
                                                      dateRangePickerSelectionChangedArgs
                                                          .value
                                                          .toString()]!),
                                                ],
                                              )),
                                        );
                                      },
                                    );
                                  }
                                },
                                cancelText: '',
                                confirmText: 'Send Mail',
                                onSubmit: (p0) => sendMail(
                                    context,
                                    Provider.of<AdminEmployeesProvider>(context,
                                            listen: false)
                                        .getEmpWithID!),
                              ),
                            ),
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
                                'Opted',
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
                          _options(
                              color: Colors.grey.shade300,
                              text: const Text(
                                'No Status',
                                style: TextStyle(fontSize: 10),
                              )),
                        ],
                      ),
                    ),
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
                      child: SpinKitCircle(
                        color: Color.fromARGB(255, 185, 147, 255),
                      ),
                    ),
                  ),
              ],
            ),
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

  Future<void> sendMail(BuildContext context, UserModel thisEmpData) async {
    Provider.of<AdminEmployeesProvider>(context, listen: false).isMailLoading =
        true;

    final dir = await getExternalStorageDirectory();

    DateTime now = DateTime.now();

    // Create a new Excel workbook
    final excel.Workbook workbook = excel.Workbook();

    // Add a worksheet to the workbook
    final excel.Worksheet sheet = workbook.worksheets[0];

    excel.Style style = workbook.styles.add('style');

    style.wrapText = true;

    // Set the worksheet name
    sheet.name = '${thisEmpData.userName}' 's Meals data';

    // Append headers
    sheet
        .getRangeByIndex(1, 1)
        .setText('${thisEmpData.userName}(${thisEmpData.employee_id})');

    sheet.getRangeByIndex(3, 1).setText('Date');
    sheet.getRangeByIndex(3, 2).setText('Status');
    sheet.getRangeByIndex(3, 3).setText('Reason');

    List<DateTime> rangeDates = List.generate(
        now.difference(DateTime(now.year, now.month, 1)).inDays + 1,
        (index) => DateTime(now.year, now.month, 1).add(Duration(days: index)));

    int rowIndex = 4;

    for (var date in rangeDates) {
      if (thisEmpData.opted.contains(date.toString().substring(0, 10))) {
        sheet
            .getRangeByIndex(rowIndex, 1)
            .setText(date.toString().substring(0, 10));
        sheet.getRangeByIndex(rowIndex, 2).setText('Opted');
        rowIndex++;
      } else if (thisEmpData.notOpted.keys
          .contains(date.toString().substring(0, 10))) {
        sheet
            .getRangeByIndex(rowIndex, 1)
            .setText(date.toString().substring(0, 10));
        sheet.getRangeByIndex(rowIndex, 2).setText('NotOpted');
        sheet
            .getRangeByIndex(rowIndex, 3)
            .setText(thisEmpData.notOpted[date.toString().substring(0, 10)]);
        rowIndex++;
      } else if (date.day < now.day && date.month <= now.month) {
        sheet
            .getRangeByIndex(rowIndex, 1)
            .setText(date.toString().substring(0, 10));
        sheet.getRangeByIndex(rowIndex, 2).setText('No Status');
        rowIndex++;
      }
    }

    for (var entry in thisEmpData.notOpted.entries) {
      if ((DateTime.parse(entry.key).day > now.day &&
              DateTime.parse(entry.key).month == now.month) ||
          DateTime.parse(entry.key).month > now.month) {
        sheet.getRangeByIndex(rowIndex, 1).setText(entry.key);
        sheet.getRangeByIndex(rowIndex, 2).setText('NotOpted');
        sheet
            .getRangeByIndex(rowIndex, 3)
            .setText(thisEmpData.notOpted[entry.key]);
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
          '${dir!.path}/${thisEmpData.userName}_mess_data_${DateTime.now().toString().substring(0, 10)}.xlsx';
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

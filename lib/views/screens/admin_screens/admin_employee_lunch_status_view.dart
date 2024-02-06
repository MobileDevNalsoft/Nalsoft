import "dart:io";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:flutter/material.dart";
import "package:flutter_email_sender/flutter_email_sender.dart";
import "package:meals_management/models/user_model.dart";
import "package:meals_management/providers/admin_employees_provider.dart";
import "package:meals_management/providers/user_data_provider.dart";
import "package:meals_management/views/custom_widgets/custom_calendar_card.dart";
import "package:meals_management/views/custom_widgets/custom_legend.dart";

import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";
import "package:syncfusion_flutter_xlsio/xlsio.dart" as excel;

// ignore: must_be_immutable
class EmployeeLunchStatus extends StatefulWidget {
  String? userName;
  String? empID;
  EmployeeLunchStatus({this.userName, this.empID,super.key});
  @override
  State<EmployeeLunchStatus> createState() => _EmployeeLunchStatusState();
}

class _EmployeeLunchStatusState extends State<EmployeeLunchStatus> {
  // used to work with the selected dates in SfDateRangePicker
  DateRangePickerController datesController = DateRangePickerController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    intiData();
  }

Future<void> intiData() async{
  print(_isLoading);
  Provider.of<UserDataProvider>(context,listen: false).getUserinfo(widget.userName);
  Provider.of<UserDataProvider>(context,listen: false).getUserEventsData(empID:widget.empID);
setState(() {
  _isLoading=false;
});
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
        actions: const [
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
                                height: size.height*0.025,
                                width: size.width*0.45,
                                child: Text(
                                    Provider.of<UserDataProvider>(context,
                                            listen: false)
                                        .getUserData
                                        .data!.empName.toString(),
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis
                                    )),
                              ),
                              SizedBox(
                                height: size.height*0.025,
                                width: size.width*0.45,
                                child: Text(
                                     Provider.of<UserDataProvider>(context,
                                            listen: false)
                                        .getUserData
                                        .data!.department.toString(),

                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis
                                    )),
                              ),
                             
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    CustomCalendarCard(
                      forAdmin: false,
                      selectionMode: DateRangePickerSelectionMode.single,
                      selectibleDayPredicate: (date) {
                        return false;
                      },

                      //TODO
                      onSubmit: (p0) => sendMail(context),
                      
                      onCancel: () {
                        datesController.selectedDate = null;
                      },
                      confirmText: 'Send Mail',
                      cancelText: 'Clear Selection',
                      
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
                      child: const SpinKitCircle(
                        color: Color.fromARGB(255, 185, 147, 255),
                      ),
                    ),
                  ),
              ],
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
      sheet.name = '${Provider.of<UserDataProvider>(context,listen: false).getUserData.data!.empName}' 's Meals data';

    //   // Append headers
      sheet
          .getRangeByIndex(1, 1)
          .setText('${Provider.of<UserDataProvider>(context,listen: false).getUserData.data!.empName}(${Provider.of<UserDataProvider>(context,listen: false).getUserData.data!.empId})');

      sheet.getRangeByIndex(3, 1).setText('Date');
      sheet.getRangeByIndex(3, 2).setText('Status');
      sheet.getRangeByIndex(3, 3).setText('Info');

      List<DateTime> rangeDates = List.generate(
          now.difference(DateTime(now.year, now.month, 1)).inDays + 1,
          (index) => DateTime(now.year, now.month, 1).add(Duration(days: index)));

      int rowIndex = 4;

      for (var date in rangeDates) {
        if (Provider.of<UserDataProvider>(context,listen: false).getOpted.any((element) => date.toString().substring(0, 10)==element.date) ) {
          sheet
              .getRangeByIndex(rowIndex, 1)
              .setText(date.toString().substring(0, 10));
          sheet.getRangeByIndex(rowIndex, 2).setText('Opted');
          sheet.getRangeByIndex(rowIndex, 3).setText(Provider.of<UserDataProvider>(context,listen: false).getOpted.where((element) => date.toString().substring(0, 10)==element.date).first.info );
          rowIndex++;
        } else if (Provider.of<UserDataProvider>(context,listen: false).getNotOpted.any((element) => date.toString().substring(0, 10)==element.date) ) {
          sheet
              .getRangeByIndex(rowIndex, 1)
              .setText(date.toString().substring(0, 10));
          sheet.getRangeByIndex(rowIndex, 2).setText('NotOpted');
          sheet
              .getRangeByIndex(rowIndex, 3)
              .setText(Provider.of<UserDataProvider>(context,listen: false).getOpted.where((element) => date.toString().substring(0, 10)==element.date).first.info);
          rowIndex++;
        } else if (date.day < now.day && date.month <= now.month) {
          sheet
              .getRangeByIndex(rowIndex, 1)
              .setText(date.toString().substring(0, 10));
          sheet.getRangeByIndex(rowIndex, 2).setText('No Status');
          rowIndex++;
        }
      }

      for (var date in Provider.of<UserDataProvider>(context, listen: false).getNotOpted) {
        if ((DateTime.parse(date.date!).day > now.day &&
                DateTime.parse(date.date!).month == now.month) ||
            DateTime.parse(date.date!).month > now.month) {
          sheet.getRangeByIndex(rowIndex, 1).setText(date.date!);
          sheet.getRangeByIndex(rowIndex, 2).setText('NotOpted');
          sheet
              .getRangeByIndex(rowIndex, 3)
              .setText(date.info);
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
            '${dir!.path}/${Provider.of<UserDataProvider>(context,listen: false).getUserData.data!.empName}_mess_data_${DateTime.now().toString().substring(0, 10)}.xlsx';
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
    //     // ignore: use_build_context_synchronously
        Provider.of<AdminEmployeesProvider>(context, listen: false)
            .isMailLoading = false;
    //     // Send email
        await FlutterEmailSender.send(email);
      } catch (error) {
        // Handle the error
        print('Error sending email: $error');
      }
  }
}

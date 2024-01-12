import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:meals_management_with_firebase/providers/employee_update_upcoming_status_provider.dart";
import "package:meals_management_with_firebase/services/database_services.dart";
import "package:provider/provider.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";

// ignore: must_be_immutable
class UpdateLunchStatus extends StatelessWidget {
  UpdateLunchStatus({super.key});

  DatabaseServices _db = DatabaseServices();

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
        body: Consumer<StatusProvider>(
          builder: (context, provider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: size.height * 0.01,
                ),
                const Text(
                  'Select Reason',
                  style: TextStyle(fontSize: 15),
                ),
                DropdownButton<String>(
                  value: provider.getReason,
                  onChanged: (String? newValue) {
                    provider.setReason(newValue!);
                  },
                  items: <String>['Single day', 'Multiple days', 'Vacation']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(
                  width: size.width * 0.95,
                  child: Card(
                    // ignore: sort_child_properties_last
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
                        SfDateRangePicker(
                          showActionButtons: true,
                          allowViewNavigation: true,
                          selectionMode: provider.getReason == 'Multiple days'
                              ? DateRangePickerSelectionMode.multiple
                              : provider.getReason == 'Vacation'
                                  ? DateRangePickerSelectionMode.extendableRange
                                  : DateRangePickerSelectionMode.single,
                          showNavigationArrow: true,
                          onSubmit: (p0) {
                            // _db.pushEvents(p0 as List<DateTime>?);
                          },
                        )
                      ],
                    ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    elevation: 8,
                  ),
                ),
                Image.asset("assets/images/food_png.png"),
              ],
            );
          },
        ));
  }
}

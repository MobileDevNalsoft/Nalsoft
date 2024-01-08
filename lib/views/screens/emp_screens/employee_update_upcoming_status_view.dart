import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:meals_management_with_firebase/providers/employee_update_upcoming_status_provider.dart";
import "package:provider/provider.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";

class UpdateLunchStatus extends StatelessWidget {

  DateRangePickerController dateController = DateRangePickerController();

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    var now = DateTime.now();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        // title: const Text("Lunch Status"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.account_circle_sharp))
        ],
        backgroundColor: Color.fromARGB(100, 179, 110, 234),
        elevation: 4,
        toolbarHeight: 65,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50))),
      ),
      body: Consumer<StatusProvider>(
        builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: size.height*0.01,),
              Text('Select Reason', style: TextStyle(fontSize: 15),),
              DropdownButton<String>(
                value: provider.getReason,
                onChanged: (String? newValue) {
                  dateController.backward;
                  provider.setReason(newValue!);
                },
                items: <String>['Single day leave', 'Multiple day leave', 'Vacation']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ),
                ).toList(),
              ),
              SizedBox(
                width: size.width*0.95,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, top: 4),
                        child: Text('Lunch Calendar'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 18),
                        child: Text(
                          '${DateFormat('EEEE').format(now).substring(
                              0, 3)}, ${DateFormat('MMMM')
                              .format(now)
                              .substring(0, 3)} ${now.day}',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Divider(),
                      SfDateRangePicker(
                        controller: dateController,
                        showActionButtons: true,
                        allowViewNavigation: true,
                        selectionMode: provider.getReason == 'Multiple day leave' ? DateRangePickerSelectionMode.multiple
                                          : provider.getReason == 'Vacation' ? DateRangePickerSelectionMode.extendableRange
                                            : DateRangePickerSelectionMode.single,
                        showNavigationArrow: true,
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  elevation: 8,
                ),
              ),
              Image.asset("assets/images/food_png.png"),
            ],
          );
        },
      )
    );
  }
}


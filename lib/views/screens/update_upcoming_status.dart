import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:meals_management/providers/events_provider.dart";
import "package:meals_management/providers/login_provider.dart";
import "package:provider/provider.dart";
import "package:syncfusion_flutter_datepicker/datepicker.dart";

class UpdateLunchStatus extends StatelessWidget {

  DateRangePickerController dateController = DateRangePickerController();

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    var now = DateTime.now();
    var uid= FirebaseAuth.instance.currentUser?.uid;
    print("uid${uid}");
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
      body: Consumer<EventsProvider>(
        builder: (context, provider, child) {
          print(provider.reason);
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: size.height*0.01,),
              Text('Select Reason', style: TextStyle(fontSize: 15),),
              DropdownButton<String>(
                value: provider.reason,
                onChanged: (String? newValue) {
                  dateController.backward;
                  provider.setReason(newValue!);
                },
                items: <String>['Single day', 'Multiple day', 'Vacation']
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
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  elevation: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5,),
                      const Padding(
                        padding: EdgeInsets.only(left: 18.0, top: 4),
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
                   Consumer<LoginProvider>(builder: (context, loginProvider, child) {
                     return SfDateRangePicker(
                    controller: dateController,
                    showActionButtons: true,
                    allowViewNavigation: true,
                    selectionMode: provider.reason == 'Multiple day' ? DateRangePickerSelectionMode.multiple
                                      : provider.reason == 'Vacation' ? DateRangePickerSelectionMode.extendableRange
                                        : DateRangePickerSelectionMode.single,
                    showNavigationArrow: true,
                    onSubmit: (selectedDates) {
                      // print(selectedDates);
                      provider.updateEvents(selectedDates,provider.reason,uid!,loginProvider);
                    },
                                         );
                   },)],
                  ),
                ),
              ),
              Image.asset("assets/images/food.png"),
            ],
          );
        },
      )
    );
  }
}

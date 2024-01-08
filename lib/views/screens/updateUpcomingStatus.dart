import "package:flutter/material.dart";
import "package:intl/intl.dart";
import 'package:mess_management/providers/userProvider.dart';
import "package:provider/provider.dart";
import "package:table_calendar/table_calendar.dart";
import '../../../../providers/emp_home_provider.dart';


class UpdateLunchStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        // title: const Text("Lunch Status"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.account_circle_rounded))

        ],
        backgroundColor: Color.fromARGB(100, 179, 110, 234),
        elevation: 4,
        toolbarHeight: 65,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50))),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black26
              ),
                color: Color.fromRGBO(236, 230, 240, 100),
                borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.all(16.0),
            margin: EdgeInsets.only(top: 16, left: 8.0, right: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Reason"),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Enter the reason for the update...",
                      hintStyle: TextStyle(color: Colors.black38),
                      border: InputBorder.none),
                )
              ],
            ),
          ),
          SizedBox(height: 15,),
          UpdateStatusCalender(),
          Expanded(child: SizedBox()),
          ElevatedButton(onPressed: () {}, child: Text("Save")),
          Image.asset("assets/images/food.png"),
        ],
      ),
    );
  }
}

class UpdateStatusCalender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 4),
              child: Text('Lunch Calendar'),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, left: 18),
              child: Text(
                '${DateFormat('EEEE').format(now).substring(
                    0, 3)}, ${DateFormat('MMMM')
                    .format(now)
                    .substring(0, 3)} ${now.day}',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Divider(),
            Consumer<HomePageModel>(
              builder: (context, provider, child) {
                return TableCalendar(
                  rowHeight: 35,
                  focusedDay: now,
                  firstDay: DateTime(2023),
                  lastDay: DateTime(2025),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(fontSize: 14),
                    headerPadding: EdgeInsets.symmetric(
                        vertical: 0),
                  ),
                  
                  daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                          color: Colors.black),
                      weekendStyle: TextStyle(
                          color: Colors.black45)
                  ),
                  calendarStyle: CalendarStyle(
                    todayTextStyle: TextStyle(color: Colors.black),
                    todayDecoration: BoxDecoration(
                      color: Color.fromARGB(100, 179, 110, 234),
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                    weekendTextStyle: const TextStyle(
                        color: const Color(0xFF5A5A5A),
                        fontStyle: FontStyle.italic),
                    weekendDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.shade100),
                  ),
                  selectedDayPredicate: (day) =>
                  false,
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, day, focusedDay) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.green.shade400,
                          // Customize color for the selected date
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            day.day.toString(),
                            style: TextStyle(
                                color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        elevation: 8,
      ),
    );
  }
}
import "package:flutter/material.dart";
import "package:table_calendar/table_calendar.dart";

void main(){
  runApp(const MaterialApp(home:Calender()));
}

class Calender extends StatelessWidget {
  const Calender({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TableCalendar(
        rowHeight: 35,
        focusedDay: DateTime.now(),
        firstDay: DateTime(2023),
        lastDay: DateTime(2025),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleTextStyle: TextStyle(fontSize: 14),
          headerPadding: EdgeInsets.symmetric(vertical: 0),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.black),
            weekendStyle: TextStyle(color: Colors.black45)),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.purpleAccent.shade100,
            shape: BoxShape.circle,
          ),
          outsideDaysVisible: false,
          weekendTextStyle: const TextStyle(
              color: const Color(0xFF5A5A5A), fontStyle: FontStyle.italic),
          weekendDecoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.red.shade100),
        ),
        // selectedDayPredicate: (day) => day == provider.getSelectedDate,
        // onDaySelected: (selectedDay, focusedDay) {
        //   showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         content: SizedBox(
        //             width: size.width * 0.6,
        //             height: size.height * 0.22,
        //             child: Consumer<HomePageModel>(
        //               builder: (context, value, child) {
        //                 return Form(
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     children: [
        //                       RadioListTile<int>(
        //                           title: Text('Opt and Sign'),
        //                           value: 1,
        //                           groupValue: provider.getRadioValue,
        //                           onChanged: (value) {
        //                             provider.setRadioValue(value);
        //                           }),
        //                       RadioListTile<int>(
        //                           title: Text('Not opt'),
        //                           value: 2,
        //                           groupValue: provider.getRadioValue,
        //                           onChanged: (value) {
        //                             provider.setRadioValue(value);
        //                           }),
        //                       SizedBox(
        //                         height: 8,
        //                       ),
        //                       Row(
        //                         mainAxisAlignment: MainAxisAlignment.end,
        //                         children: [
        //                           ElevatedButton(
        //                             child: Text(
        //                               'Cancel',
        //                               style: TextStyle(color: Colors.black),
        //                             ),
        //                             onPressed: null,
        //                             style: ButtonStyle(
        //                                 minimumSize: MaterialStateProperty.all(
        //                                     Size(50, 35)),
        //                                 backgroundColor: MaterialStatePropertyAll(
        //                                     Colors.white),
        //                                 elevation: MaterialStatePropertyAll(5)),
        //                           ),
        //                           SizedBox(
        //                             width: 5,
        //                           ),
        //                           ElevatedButton(
        //                             child: Text(
        //                               'Proceed',
        //                               style: TextStyle(color: Colors.white),
        //                             ),
        //                             onPressed: null,
        //                             style: ButtonStyle(
        //                                 minimumSize: MaterialStateProperty.all(
        //                                     Size(50, 35)),
        //                                 backgroundColor: MaterialStatePropertyAll(
        //                                     Colors.deepPurpleAccent.shade200),
        //                                 elevation: MaterialStatePropertyAll(5)),
        //                           )
        //                         ],
        //                       )
        //                     ],
        //                   ),
        //                 );
        //               },
        //             )),
        //       );
        //     },
        //   );
        // },
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors
                    .green.shade400, // Customize color for the selected date
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  day.day.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_widgets/src.dart';
import 'package:intl/intl.dart';
import 'package:meals_management/providers/meeting_rooms_management/home_view_provider.dart';
import 'package:meals_management/providers/meeting_rooms_management/meeting_room_provider.dart';
import "package:provider/provider.dart";

class MeetingRoom extends StatefulWidget {
  const MeetingRoom({super.key});

  @override
  State<MeetingRoom> createState() => _MeetingRoomState();
}

class _MeetingRoomState extends State<MeetingRoom> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<MeetingRoomProvider>(context, listen: false).addFreeSlots();
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<MeetingRoomProvider>(context, listen: false)
        .meetingRoom
        .bookingsServicesList);
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: AspectRatio(
      aspectRatio: size.height / size.width,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text("Meeting Room 8",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              )),
          backgroundColor: Colors.blueGrey.shade400,
        ),
        backgroundColor: Colors.blueGrey.shade100,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                onTap: () async {
                  Provider.of<HomeViewProvider>(context, listen: false)
                      .currentDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialDate:
                        Provider.of<HomeViewProvider>(context, listen: false)
                                .currentDate ??
                            DateTime.now(),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        DateFormat('yMMMMEEEEd')
                            .format(Provider.of<HomeViewProvider>(context,
                                    listen: true)
                                .currentDate)
                            .toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        )),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 24,
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: size.height * 0.8,
                  width: size.width * 0.9,
                  child: ListView(
                    children:
                        Provider.of<MeetingRoomProvider>(context, listen: true)
                            .meetingRoom
                            .bookingsServicesList!
                            .map((bookingSlot) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: bookingSlot.user.username != ""
                              ? Color.fromRGBO(247, 194, 194, 0.612)
                              : Colors.white,
                        ),
                        height: size.height * 0.1,
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, left: 24),
                                  child: Text(
                                      style: TextStyle(fontSize: 18),
                                      "${bookingSlot.duration.start.toString().substring(11, 16)}  -  ${bookingSlot.duration.end.toString().substring(11, 16)}"),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 8.0, left: 24.0),
                                  child: Text(bookingSlot.user.userID != ""
                                      ? "Occupied by:  ${bookingSlot.user.userID}"
                                      : "Available"),
                                )
                              ],
                            ),
                            if (bookingSlot.user.userID == "")
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: CustomWidgets.CustomElevatedButton(
                                  onPressed: () {
                                    Provider.of<MeetingRoomProvider>(context,
                                                listen: false)
                                            .selectedStartTime =
                                        bookingSlot.duration.start;
                                    Provider.of<MeetingRoomProvider>(context,
                                                listen: false)
                                            .selectedEndTime =
                                        bookingSlot.duration.end;

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.all(0),
                                          content: SizedBox(
                                            height: size.height * 0.216,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon:
                                                            Icon(Icons.close)),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Start Time",
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          "End Time",
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          ":",
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          ":",
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          highlightColor:
                                                              Colors.white,
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      maxHeight:
                                                                          size.height *
                                                                              0.3),
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      builder) {
                                                                return SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .copyWith()
                                                                          .size
                                                                          .height /
                                                                      3,
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        "Start Time",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                      // Time picker
                                                                      Expanded(
                                                                        child:
                                                                            CupertinoDatePicker(
                                                                          mode:
                                                                              CupertinoDatePickerMode.time,
                                                                          use24hFormat:
                                                                              true,
                                                                          initialDateTime: bookingSlot
                                                                              .duration
                                                                              .start,
                                                                          minimumDate: bookingSlot
                                                                              .duration
                                                                              .start,
                                                                          maximumDate: bookingSlot
                                                                              .duration
                                                                              .end,
                                                                          onDateTimeChanged:
                                                                              (newTime) {
                                                                            Provider.of<MeetingRoomProvider>(context, listen: false).selectedStartTime =
                                                                                newTime;
                                                                            print("start time ${Provider.of<MeetingRoomProvider>(context, listen: false).selectedStartTime}");
                                                                          },
                                                                        ),
                                                                      ),
                                                                      CustomWidgets.CustomElevatedButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          backgroundColor: MaterialStateProperty.all(Colors.blueGrey.shade200),
                                                                          child: Text("Set"))
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Text(
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                              "${Provider.of<MeetingRoomProvider>(context, listen: true).selectedStartTime.toString().substring(11, 16)}"),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      maxHeight:
                                                                          size.height *
                                                                              0.3),
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      builder) {
                                                                return SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .copyWith()
                                                                          .size
                                                                          .height /
                                                                      3,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        "End Time",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            CupertinoDatePicker(
                                                                          mode:
                                                                              CupertinoDatePickerMode.time,
                                                                          use24hFormat:
                                                                              true,
                                                                          initialDateTime: bookingSlot
                                                                              .duration
                                                                              .start,
                                                                          minimumDate: bookingSlot
                                                                              .duration
                                                                              .start,
                                                                          maximumDate: bookingSlot
                                                                              .duration
                                                                              .end,
                                                                          onDateTimeChanged:
                                                                              (newTime) {
                                                                            Provider.of<MeetingRoomProvider>(context, listen: false).selectedEndTime =
                                                                                newTime;
                                                                            print("end time ${Provider.of<MeetingRoomProvider>(context, listen: false).selectedEndTime}");
                                                                          },
                                                                        ),
                                                                      ),
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: const Text(
                                                                            'Set'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Text(
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                              "${Provider.of<MeetingRoomProvider>(context, listen: false).selectedEndTime.toString().substring(11, 16)}"),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.2,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.021,
                                                ),
                                                CustomWidgets
                                                    .CustomElevatedButton(
                                                  onPressed: () {
                                                    Provider.of<MeetingRoomProvider>(
                                                            context,
                                                            listen: false)
                                                        .bookSlot();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Book now"),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.blueGrey
                                                              .shade200),
                                                )
                                              ],
                                            ),
                                          ),
                                          actions: [],
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Book now"),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blueGrey.shade200),
                                ),
                              )
                          ],
                        ),
                      );
                    }).toList(),
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}

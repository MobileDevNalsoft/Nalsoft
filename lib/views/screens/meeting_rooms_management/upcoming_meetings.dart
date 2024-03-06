import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meals_management/providers/meeting_rooms_management/home_view_provider.dart';
import 'package:provider/provider.dart';

class UpcomingMeetingsView extends StatefulWidget {
  @override
  State<UpcomingMeetingsView> createState() => _UpcomingMeetingsView();
}

class _UpcomingMeetingsView extends State<UpcomingMeetingsView> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: AspectRatio(
        aspectRatio: size.height / size.width,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Upcoming Meetings'),
            backgroundColor: Colors.blueGrey.shade400,
          ),
          backgroundColor: Colors.blueGrey.shade100,
          body: Padding(
            padding: EdgeInsets.only(top: 10, left: 9),
            child: SizedBox(
              height: size.height,
              width: size.width * 0.95,
              child: Consumer<HomeViewProvider>(
                  builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.getUser.myBookings!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Container(
                        height: size.height * 0.125,
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('EEEE, MMM dd yyyy').format(
                                      provider.getUser.myBookings![index]
                                          .duration.start),
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(provider
                                    .getUser.myBookings![index].roomName),
                                SizedBox(
                                  height: size.height * 0.055,
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    '${DateFormat.Hm().format(provider.getUser.myBookings![index].duration.start)} to ${DateFormat.Hm().format(provider.getUser.myBookings![index].duration.end)}',
                                    style: TextStyle(fontSize: 13)),
                                SizedBox(
                                  height: size.height * 0.003,
                                ),
                                Text(
                                    'Floor ${provider.getUser.myBookings![index].floor}',
                                    style: TextStyle(fontSize: 13)),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_forever,
                                    size: 20,
                                    color: Colors.blueGrey.shade400,
                                  ),
                                  onPressed: () {
                                    provider.deleteBooking(
                                        provider.getUser.myBookings![index]
                                            .roomName,
                                        provider
                                            .getUser.myBookings![index].floor,
                                        provider.getUser.myBookings![index]
                                            .duration,
                                        provider.getUser.userID);
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

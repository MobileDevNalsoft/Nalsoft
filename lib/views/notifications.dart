import 'package:custom_widgets/src.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/providers/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

class NotificationsView extends StatefulWidget {
  @override
  State<NotificationsView> createState() => _NotificationsView();
}

class _NotificationsView extends State<NotificationsView> {

  @override
  void initState() {
    super.initState();
    Provider.of<FirebaseProvider>(context, listen: false).getNotifications();

  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: AspectRatio(
        aspectRatio: size.height / size.width,
        child: Scaffold(
          appBar: AppBar(

            centerTitle: true,
            title: Text('Notifications'),
            backgroundColor:Color.fromARGB(100, 179, 110, 234),
            shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
          ),
         
          body: Stack(
            children:[ Center(
              child: SizedBox(
                height: size.height,
                width: size.width * 0.95,
                child: Consumer<FirebaseProvider>(
                    builder: (context, provider, child) {
                      print("consumer ${provider.notifications}");
                      print(provider.notifications!['message'].length);
                  return provider.notifications!['message'].length==0?Text("No notifications",textAlign: TextAlign.center,):ListView.builder(
              
                    itemCount: provider.notifications!['message'].length??0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:  EdgeInsets.only(top:10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(236, 230, 240, 100),
                          ),
                          
                          padding: EdgeInsets.all(10 ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider.notifications!['message'][index]['title'],style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),),
                              Text(provider.notifications!['message'][index]['description'],
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                
                                color: Colors.black54,
                                fontWeight: FontWeight.bold
                              ),)
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
                 if (Provider.of<FirebaseProvider>(context, listen: true)
                  .isLoading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                      color: Colors.black38,
                      child: CustomWidgets.CustomCircularLoader()),
                ),
          ]),
        ),
      ),
    );
  }
}

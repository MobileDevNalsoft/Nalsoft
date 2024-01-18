import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:meals_management/providers/digital_signature_provider.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Preview extends StatefulWidget {
  Preview({super.key});

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  @override
  void initState() {
    super.initState();
  }

  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 242, 250),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 247, 242, 250),
          toolbarHeight: 80,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteManagement.employeeHomePage, (route) => false);
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.62,
              color: const Color.fromARGB(255, 247, 242, 250),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 50, top: 50),
                child: Card(
                  color: const Color.fromARGB(255, 234, 221, 255),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20, right: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${DateFormat('EEEE').format(now).substring(0, 3)}, ${DateFormat('MMMM').format(now).substring(0, 3)} ${now.day}',
                              style: const TextStyle(fontSize: 25),
                            ),
                            Text(
                              DateFormat.jm().format(now),
                              style: const TextStyle(fontSize: 25),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 247, 242, 250),
                        thickness: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20, right: 20, bottom: 20),
                        child: Row(
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Employee Name'),
                                Text('Employee ID'),
                                Text('Employee Floor no.')
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Column(
                              children: [Text(':'), Text(':'), Text(':')],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .getUsername!),
                                Text(Provider.of<UserDataProvider>(
                                  context,
                                ).getEmpID!),
                                Text(Provider.of<UserDataProvider>(
                                  context,
                                ).getFloor!)
                              ],
                            )
                          ],
                        ),
                      ),
                      const Text(
                        'Successfully Signed\n         for today',
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(
                        Icons.task_alt_sharp,
                        color: Colors.green.shade800,
                        size: 40,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 100,
                              width: 120,
                              color: Colors.white,
                              // child: FutureBuilder<Uint8List>(
                              //   future: getTemporaryDirectory().then((dir) =>
                              //       File('${dir.path}/cached_image.jpg')
                              //           .readAsBytes()),
                              //   builder: (context, snapshot) {
                              //     if (snapshot.hasData) {
                              //       return Image.memory(snapshot.data!);
                              //     } else {
                              //       return Center(
                              //           child: SpinKitCircle(color: Colors.blue, size: 50.0),);
                              //     }
                              //   },
                              // ),
                              // child: Image.memory(getTemporaryDirectory().then((dir) => File('${dir.path}/cached_image.jpg').readAsBytes()) as Uint8List ),
                               child:Image.network(
        Provider.of<UserDataProvider>(context, listen: false).getOptedWithURL[DateTime(now.year, now.month, now.day, 0,0,0,0).toString()],
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress != null) {
            print(loadingProgress);
           return Center(
            
            child:SpinKitCircle(color:Color.fromARGB(255, 179, 157, 219), size: 50.0),
          );
          }
          return child;
        },
      ),
                              // child: Image.network(
                              //    Provider.of<UserDataProvider>(context, listen: false).getOptedWithURL[DateTime(now.year, now.month, now.day, 0,0,0,0).toString()],
                              //    loadingBuilder:
                              //       (context, child, loadingProgress) {
                              //       if (loadingProgress==null){
                              //         print(child);
                              //         return SpinKitCircle(color: Colors.blue, size: 50.0);
                              //       }return 
                              //     // print("progress $loadingProgress $child");
                              //     // return ;
                              //     }),
                                  // return const Center(
                                  //   child:SpinKitCircle(color: Colors.blue, size: 50.0),
                                  // );
                                // },
                              )
                            ,
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

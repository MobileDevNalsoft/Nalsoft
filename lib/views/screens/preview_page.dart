import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meals_management/providers/digital_signature_provider.dart';
import 'package:meals_management/providers/emp_home_provider.dart';
import 'package:meals_management/providers/user_provider.dart';
import 'package:meals_management/views/screens/route_management.dart';
import 'package:meals_management/views/widgets/custom_button.dart';
// import 'package:meals_management_with_firebase/providers/employee_home_provider.dart';
// import 'package:meals_management_with_firebase/views/custom_widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
// import 'package:screenshot/screenshot.dart';

// ignore: must_be_immutable
class Preview extends StatefulWidget {

  Preview({super.key});

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  ScreenshotController screenshotController = ScreenshotController();

@override
void initState() {
    super.initState();
    getDigitalSignature();
  }

Future<void> getDigitalSignature()async{
  Timer timer;
  timer = Timer(Duration(seconds: 5), () async {
  await Provider.of<SignatureProvider>(context,listen: false).getSignature();
  print("got the signature");
  });
   
}

  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color.fromARGB(255, 247, 242, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 242, 250),
        toolbarHeight: 80,
        leading: IconButton(icon: Icon(Icons.arrow_back,),onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, RouteManagement.userHomePage, (route) => false);
        },),
      ),
      body: Provider.of<SignatureProvider>(context,listen:true).isUploaded?
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
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
                                  Text(Provider.of<UserProvider>(context,)
                                      .user.username),
                                  Text(Provider.of<UserProvider>(context,)
                                      .user.employee_id),
                                   Text(Provider.of<UserProvider>(context,)
                                      .user.floor)
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
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 100,
                                width: 120,
                                color: Colors.white,
                                child: Consumer<SignatureProvider>(builder: (context, value, child) { return 
                                  value.imageBytes==null?Center(child: CircularProgressIndicator(),):Image(image: MemoryImage(value.imageBytes));
                                },)
                              ),
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
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    onPressed: () => null,
                    color: MaterialStatePropertyAll(Colors.green.shade500),
                    child: const Text(
                      'Download',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 130,
          )
        ],
      ):Center(child: CircularProgressIndicator()),
    );
  }
}
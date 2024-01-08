
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:mess_management/screens/user_home_page_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:gallery_saver/gallery_saver.dart';

class Preview extends StatelessWidget{

  // ScreenshotController screenshotController = ScreenshotController();

  final now = DateTime.now();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 242, 250),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 247, 242, 250),
          title: Text('Preview'),
          centerTitle: true,
          toolbarHeight: 80,
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Expanded(
          //   flex:8,
          //   child: Screenshot(
          //     controller: screenshotController,
          //     child: Container(
          //       width: MediaQuery.of(context).size.width,
          //       height: MediaQuery.of(context).size.height,
          //       color: Color.fromARGB(255, 247, 242, 250),
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50, top: 50),
          //         child: Card(
          //           color: Color.fromARGB(255,234, 221, 255),
          //           elevation: 10,
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.spaceAround,
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 10),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Text('${DateFormat('EEEE').format(now).substring(0,3)}, ${DateFormat('MMMM').format(now).substring(0,3)} ${now.day}',
          //                       style: TextStyle(fontSize: 25),
          //                     ),
          //                     Text('${DateFormat.jm().format(now)}',
          //                       style: TextStyle(fontSize: 25),
          //                     )
          //                   ],
          //                 ),
          //               ),
          //               Divider(
          //                 color: Color.fromARGB(255, 247, 242, 250),
          //                 thickness: 4,
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 20),
          //                 child: Row(
          //                   children: [
          //                     Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text('Employee Name'),
          //                         Text('Employee ID'),
          //                         Text('Employee Floor no.')
          //                       ],
          //                     ),
          //                     SizedBox(width: 20,),
          //                     Column(
          //                       children: [
          //                         Text(':'),
          //                         Text(':'),
          //                         Text(':')
          //                       ],
          //                     ),
          //                     SizedBox(width: 20,),
          //                     Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(Provider.of<HomePageModel>(context).getUserName),
          //                         Text('XXXXXX'),
          //                         Text('08')
          //                       ],
          //                     )
          //                   ],
          //                 ),
          //               ),
          //               Text('Successfully Signed\n         for today',
          //                 style: TextStyle(fontSize: 20),
          //               ),
          //               Icon(Icons.task_alt_sharp,
          //                 color: Colors.green.shade800,
          //                 size: 40,
          //               ),
          //               Expanded(
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.end,
          //                   children: [
          //                     Container(
          //                       height: 100,
          //                       width: 120,
          //                       color: Colors.white,
          //                     ),
          //                     SizedBox(width: 20,),
          //                   ],
          //                 ),
          //               ),
          //               SizedBox(height: 20,),
          //             ],
          //           ),
          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          //         ),
          //       ),
          //     ),
          //   ),
          
          // ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ElevatedButton(
                  //   child: Text('Download Preview',
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  //   onPressed: () => _saveScreenshot(),
                  //   style: ButtonStyle(
                  //     backgroundColor: MaterialStatePropertyAll(Colors.green.shade500),
                  //     elevation: MaterialStatePropertyAll(10)
                  //   ),
                  // )
              
                ],
              ),
            ),
          ),
          SizedBox(height: 130,)
        ],
      ),
    );
  }}

//   Future<void> _saveScreenshot() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final imagePath = '${directory.path}/screenshot.png';

//     final image = await screenshotController.captureAndSave(
//       imagePath,
//       pixelRatio: 2,
//     );

//     final result = await GallerySaver.saveImage(image!);
//     print(result);
//   }
// }
import "package:flutter/material.dart";
import 'package:mess_management/views/screens/route_management.dart';

void main() {
  runApp(MaterialApp(
    home: AdminHomePage(),
  ));
}

class AdminHomePage extends StatelessWidget {
  var size, height, width;
  final GlobalKey<ScaffoldState>  _scaffoldKey = GlobalKey<ScaffoldState>();
  List departments = ["Dept1", "Dept2", "Dept3", "Dept4", "Dept5", "Dept4", "Dept5", "Dept4", "Dept5"];
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(child: Column(children: [TextButton(onPressed: (){Navigator.of(context).popUntil((route) => route.isFirst);
}, child: Text("Log out"))],),),
        resizeToAvoidBottomInset: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color.fromRGBO(236, 230, 240, 100),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () { _scaffoldKey.currentState?.openDrawer();},
                    ),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search employee"),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            const Row( mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 16,),
                Text("Select Department",style: TextStyle(color:Color.fromRGBO(73, 69, 79, 100))),
              ],
            ),
            Expanded(
              child: Scrollbar(
                child: ListView(
                  children: departments
                      .map((item) => Container(
                        // color: Colors.amber,
                        margin: const EdgeInsets.only(left:10.0,right:10.0,bottom:4.0),
                        
                        height:height*0.1,
                        child: Card(
                          elevation: 3,
                              child: TextButton(onPressed: () {
                                 Navigator.pushNamed(context, RouteManagement.employees);
                              },
                              style: TextButton.styleFrom(alignment:Alignment.centerLeft),
                              child:Text(item,style: TextStyle(fontSize: 16,color: Colors.black87)),),
                            ),
                      ))
                      .toList(),
                ),
              ),
            ),
            ElevatedButton(onPressed: (){}, child: const Text("Generate CSV")),
            Image.asset("assets/images/food.png")
          ],
        ),
      ),
    );
  }
}

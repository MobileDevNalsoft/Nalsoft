import 'package:flutter/material.dart';
import 'package:mess_management/views/screens/route_management.dart';
import 'package:mess_management/views/widgets/infoCard.dart';

void main(){
  runApp(MaterialApp(home: Employees(),));
}

class Employees extends StatelessWidget{
  var size, height, width;
  List empList=["Emp1","Emp2","Emp3","Emp4","Emp5","Emp6","Emp7","Emp8","Emp9","Emp10","Emp11","Emp12"] ;

  @override
  Widget build(BuildContext context){
      size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return SafeArea(  child: Scaffold(
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
                      icon: Icon(Icons.arrow_back,),
                      onPressed: () { Navigator.pop(context);},
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
              Padding(
                padding: const EdgeInsets.only(left:16.0,right:16.0),
                child: InfoCard(content: {"Department":"Dept1"}),
              ),
              SizedBox(height: 16,),
            const Row( mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 16,),
                Text("Select Employee",style: TextStyle(color:Color.fromRGBO(73, 69, 79, 100)),),
              ],
            ),
            Expanded(
              child: Scrollbar(
                child: ListView(
                  children: empList
                      .map((item) => Container(
                        margin: const EdgeInsets.only(left:10.0,right:10.0,bottom:4.0),
                        height:height*0.1,
                        child: Card(elevation: 3,
                              child: TextButton(onPressed: () {
                                 Navigator.pushNamed(context, RouteManagement.employeeLunchStatus);
                              },
                              style: TextButton.styleFrom(alignment:Alignment.centerLeft),
                              child:Text(item,style: TextStyle(fontSize: 16,color: Colors.black87),),),
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
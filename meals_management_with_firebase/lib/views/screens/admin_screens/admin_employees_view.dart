import 'package:flutter/material.dart';

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
                      icon: Icon(Icons.menu),
                      onPressed: () {},
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
            const Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Padding(
                padding: EdgeInsets.only(left:16.0),
                child: Text("Department",style: TextStyle(fontSize: 16),),
              ),Text(':'),Padding(
                padding: EdgeInsets.only(right:16.0),
                child: Text("Dept1",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              )],),
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
                        // color: Colors.amber,
                        margin: const EdgeInsets.only(left:10.0,right:10.0,bottom:4.0),
                        
                        height:height*0.1,
                        child: Card(elevation: 3,
                              child: TextButton(onPressed: () {
                                Navigator.pushNamed(context, '/employee_lunch_status');
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
            Image.asset("assets/images/food_png.png")
          ],
        ),
      ),
    );
  }
}
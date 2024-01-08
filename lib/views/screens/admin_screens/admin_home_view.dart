import "package:flutter/material.dart";

class AdminHomePage extends StatelessWidget {
  var size, height, width;
  List departments = ["dept1", "dept2", "dept3", "dept4", "dept5", "dept4", "dept5", "dept4", "dept5"];
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return SafeArea(
      child: Scaffold(
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
                                Navigator.pushNamed(context, '/admin_employees');
                              },
                              style: TextButton.styleFrom(alignment:Alignment.centerLeft),
                              child:Text(item),),
                            ),
                      ))
                      .toList(),
                ),
              ),
            ),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/download_csv');
            }, child: const Text("Generate CSV")),
            Image.asset("assets/images/food_png.png")
          ],
        ),
      ),
    );
  }
}

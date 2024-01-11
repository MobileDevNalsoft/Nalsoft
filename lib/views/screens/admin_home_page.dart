import "package:flutter/material.dart";
import "package:meals_management/providers/department_provider.dart";
import "package:meals_management/providers/emp_home_provider.dart";
import "package:meals_management/services/user_authentication.dart";
import "package:meals_management/views/screens/route_management.dart";
import "package:provider/provider.dart";

class AdminHomePage extends StatefulWidget {
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  var size, height, width;

  // List departments = ["dept1", "dept2", "dept3", "dept4", "dept5", "dept4", "dept5", "dept4", "dept5"];
@override
void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    Provider.of<DeptProvider>(context,listen: false).updateDepartments();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: size.height * 0.13,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(100, 179, 110, 234),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 15),
                    child: Text('Hi,\n${Provider.of<HomePageProvider>(context, listen: false).getUserName}',
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Switch(
                    value: true,
                    onChanged: (value) {
                      Navigator.pushNamedAndRemoveUntil(context, RouteManagement.userHomePage, (route) => false);
                    },
                    activeColor: Color.fromARGB(255, 181, 129, 248),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return [PopupMenuItem(
                          child: Text('Sign Out'),
                          value: 'Sign Out',
                          height: 10,
                          onTap: () {
                            FirebaseAuthService().signOutNow().then((value) => Navigator.pushNamedAndRemoveUntil(context, RouteManagement.loginPage, (route) => false));
                            print('navigated to login page');
                          }
                        )];
                      },
                      child: Icon(Icons.power_settings_new_sharp),
                    ),
                  )
                ],
              ),
            ),
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
                child: Consumer<DeptProvider>(builder: (context, value, child) {
                  return value.dept.departments!.isEmpty?Center(child: CircularProgressIndicator()):ListView(
                  children: value.dept.departments!
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
                              child:Text(item),),
                            ),
                      ))
                      .toList(),
                );
              
                },)),
            ),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, RouteManagement.download);
            }, child: const Text("Generate CSV")),
            Image.asset("assets/images/food.png")
          ],
        ),
      ),
    );
  }
}
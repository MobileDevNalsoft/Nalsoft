import 'package:flutter/material.dart';
import 'package:meals_management/providers/auth_provider.dart';
import 'package:meals_management/views/screens/authentication/login_view.dart';
import 'package:meals_management/views/screens/emp_screens/home_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
 

  

 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  Provider.of<AuthenticationProvider>(context, listen: false).getAuthToken().isNotEmpty?EmployeeHomeView():LoginView()),
            ));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: const BoxDecoration(
            image: DecorationImage(
                 opacity: 0.4,
                image: AssetImage('assets/images/background_splash.jpg'),
                fit: BoxFit.cover),
          ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 10,
            left: 10,
            
            child: Image.asset('assets/images/nalsoft_logo.png',width: MediaQuery.of(context).size.width*0.9,height:MediaQuery.of(context).size.height*0.15 ,fit: BoxFit.fitWidth,))
        ],
      ),
    );
  }
}
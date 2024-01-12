import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/providers/auth_provider.dart';
import 'package:meals_management/providers/user_provider.dart';
import 'package:meals_management/services/user_authentication.dart';
import 'package:meals_management/views/screens/route_management.dart';
import 'package:meals_management/views/widgets/custom_button.dart';
import 'package:meals_management/views/widgets/custom_snackBar.dart';
import 'package:meals_management/views/widgets/cutom_textField.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constants.dart';

class LoginView extends StatefulWidget{


  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}


class _LoginViewState extends State<LoginView> {
  final GlobalKey _formKey = GlobalKey<FormState>();


  late SharedPreferences sharedPreferences;
  FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiate();
  }

  initiate() async{
     sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            color: Colors.white, // background color of Container
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // adjusts width and height according to device dimensions
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 20,),
                Expanded(
                  flex: 3,
                  child: Image.asset('assets/images/login_page_img.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(right : 60.0, left: 70),
                  child: Image.asset('assets/images/nalsoft_logo.png'),
                ),
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15,),
                                CustomTextField(hintText: 'email',
                                  controller: _emailController,
                                  prefixIcon: Icon(Icons.person),
                                ),
                                const SizedBox(height: 15,),
                                Consumer<AuthenticationProvider>(
                                      builder: (context, provider, _) {
                                        return CustomTextField(hintText: 'password',
                                          controller: _passwordController,
                                          prefixIcon: const Icon(Icons.lock),
                                          obscureText: provider.obscurePassword,
                                          obscureChar: '*',
                                          suffixIcon: IconButton(
                                            iconSize: 20,
                                            onPressed: () =>
                                            {
                                              provider.obscureToggle(),
                                            },
                                            icon: provider.obscurePassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                                          ),
                                        );
                                      }
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const TextButton(
                                      onPressed: null,
                                      child: Text('forgot password?',
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, RouteManagement.userRegistration);
                                      },
                                      child: const Text('Register',
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 15,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Consumer<UserProvider>(builder: (context, provider, child) {
                                 return    CustomButton(
                                      child: const Text('Login',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        if(_emailController.text.isEmpty){
                                          CustomSnackBar.showSnackBar(context, 'email cannot be empty');
                                        }
                                        else if(!_emailController.text.contains('@')){
                                          CustomSnackBar.showSnackBar(context, 'email must contain @');
                                        }
                                        else if(_passwordController.text.isEmpty){
                                          CustomSnackBar.showSnackBar(context, 'password cannot be empty');
                                        }
                                        else if(_passwordController.text.length<10){
                                          CustomSnackBar.showSnackBar(context, 'password must be atleast 10 characters');
                                        }
                                        else if(!Constants.regex.hasMatch(_passwordController.text)){
                                          CustomSnackBar.showSnackBar(context, 'password must include atleast one special symbol, lowercase and uppercase letter');
                                        }
                                        else{
                                          if(_emailController.text == 'admin'){
                                          Navigator.pushNamed(context, RouteManagement.adminHomePage);
                                        }
                                        else{
                                          _signIn(context,provider);
                                        }
                                      }
                                      },
                                      );
                                
                               },)],
                                ),
                              ],
                                                      ),
                        ),
                  )
                ),
           
            ),
            Image.asset("assets/images/food.png")],
            ),
          ),
    );
  }

  void _signIn(context,provider) async {
    String email = _emailController.text.trim().toLowerCase();
    String password = _passwordController.text.trim();
    bool onSuccessfulLogin=await provider.loginUser(email,password);

    if(onSuccessfulLogin){
        print("userpage");
        sharedPreferences.setString("isLogged", "true");
          ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful')));
      Navigator.pushReplacementNamed(context, RouteManagement.userHomePage);  
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Some error has occurred'))
      );
    }
  }
}
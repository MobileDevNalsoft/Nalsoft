import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/providers/login_provider.dart';
import 'package:meals_management_with_firebase/services/firebase_auth_services.dart';
import 'package:meals_management_with_firebase/views/custom_widgets/custom_button.dart';
import 'package:meals_management_with_firebase/views/custom_widgets/custom_snackbar.dart';
import 'package:meals_management_with_firebase/views/custom_widgets/custom_textformfield.dart';
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


  SharedPreferences? sharedPreferences;
  FirebaseAuthServices _auth = FirebaseAuthServices();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiat();
  }
  initiat() async{
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
                                CustomTextFormField(hintText: 'email',
                                  controller: _emailController,
                                  prefixIcon: Icon(Icons.person),
                                ),
                                const SizedBox(height: 15,),
                                Consumer<LoginProvider>(
                                      builder: (context, provider, _) {
                                        return CustomTextFormField(hintText: 'password',
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
                                        Navigator.pushNamed(context, '/register');
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
                                    CustomButton(
                                      child: const Text('Login',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        if(_emailController.text.isEmpty){
                                          CustomSnackBar.showSnackBar(context, 'email cannot be empty');
                                        }
                                        else if(!_emailController.text.contains('@nalsoft.net')){
                                          CustomSnackBar.showSnackBar(context, 'email must contain @nalsoft.net');
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
                                          _signIn(context);
                                        }
                                      },
                                      color: MaterialStatePropertyAll(Colors.grey.shade300),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                  )
                ),
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'assets/images/food_png.png',
                    fit: BoxFit.fill, // Fill the width of the screen
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _signIn(context) async {
    String email = _emailController.text.trim().toLowerCase();
    String password = _passwordController.text.trim();

    User? user = await _auth.signInwithEmailandPassword(email, password);

    if(user!=null){
      sharedPreferences!.setString("islogged", "true");
      Navigator.pushNamed(context, '/emp_homepage');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful'))
      );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Some error has occurred'))
      );
    }
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mess_management/providers/login_provider.dart';
import 'package:mess_management/services/auth/user_authentication.dart';
import 'package:mess_management/views/widgets/CutomTextField.dart';
import 'package:mess_management/views/widgets/custom_button.dart';
import 'package:mess_management/views/widgets/custom_snackBar.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants.dart';

class LoginPage extends StatelessWidget{

  final GlobalKey _formKey = GlobalKey<FormState>();

  FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

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
                  child: Image.asset('assets/images/food.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(right : 60.0, left: 70),
                  child: Image.asset('assets/images/nalsoft_logo.png'),
                ),
                Expanded(
                  flex: 5,
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
                              Consumer<LoginProvider>(
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
                                          Navigator.pushNamed(context, '/admin_homepage');
                                        }
                                        else{
                                          _signIn(context);
                                        }
                                      }
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                ),
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'assets/images/food.png',
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

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if(user!=null){
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
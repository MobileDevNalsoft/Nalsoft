
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:meals_management_with_firebase/models/user_model.dart';
import 'package:meals_management_with_firebase/providers/signup_provider.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';
import 'package:meals_management_with_firebase/services/firebase_auth_services.dart';
import 'package:meals_management_with_firebase/utils/constants.dart';
import 'package:meals_management_with_firebase/views/custom_widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';
import '../../../providers/login_provider.dart';
import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_snackbar.dart';

class SignUpView extends StatefulWidget {

  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  List<String> deptList = [];

  final _formKey = GlobalKey<FormState>();

  DatebaseServices _db = DatebaseServices();

  FirebaseAuthServices _auth = FirebaseAuthServices();

  final _emailController = TextEditingController();

  final _empIdController =TextEditingController();

  final _createPasswordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  String department = 'Department';

  String floor = 'Floor';

  @override
  initState(){
    super.initState();
    getDeptList();
  }

  Future<void> getDeptList() async{
    final depts = await _db.getDepartments();
    setState(() {
      depts[0].forEach((key, value) => deptList.add(value));
    });
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
        body: Column(
          children: [
            RotatedBox(
              quarterTurns: 2,
              child: Image.asset('assets/images/food_png.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Image.asset('assets/images/nalsoft_logo.png'),
            ),
            Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: size.width,
                      child: Column(
                          children: [
                            SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Form(
                                key: _formKey,
                                  child: Column(
                                    children: [
                                      CustomTextFormField(controller: _emailController,hintText: 'email', prefixIcon: Icon(Icons.person),),
                                      SizedBox(height: 15,),
                                      CustomTextFormField(controller: _empIdController,hintText: 'employee id', prefixIcon: Icon(Icons.person),),
                                      SizedBox(height: 15,),
                                      Consumer<LoginProvider>(
                                          builder: (context, provider, _) {
                                            return CustomTextFormField(hintText: 'create password',
                                              controller: _createPasswordController,
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
                                      SizedBox(height: 15,),
                                      Consumer<LoginProvider>(
                                          builder: (context, provider, _) {
                                            return CustomTextFormField(hintText: 'confirm password',
                                              controller: _confirmPasswordController,
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
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Consumer<SignupProvider>(
                                            builder: (context, provider, child) {
                                              return Expanded(
                                                child: DropdownButton<String>(
                                                  value: provider.getDept,
                                                  onChanged: (String? newValue) {
                                                    department = newValue!;
                                                    provider.setDept(newValue!);
                                                  },
                                                  items: deptList.map<DropdownMenuItem<String>>(
                                                        (String value) => DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value,),
                                                    ),
                                                  ).toList(),
                                                  alignment: Alignment.center,
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(width: size.width*0.05,),
                                          Consumer<SignupProvider>(
                                            builder: (context, provider, child) {
                                              return DropdownButton<String>(
                                                value: provider.getFloor,
                                                  onChanged: (String? newValue) {
                                                  floor = newValue!;
                                                  provider.setFloor(newValue!);
                                                },
                                                items: <String>['Floor','8', '9', '1']
                                                    .map<DropdownMenuItem<String>>(
                                                      (String value) => DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                  ),
                                                ).toList(),
                                                alignment: Alignment.centerLeft,
                                              );
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  )
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ),
            const SizedBox(height: 15,),
            MediaQuery.of(context).viewInsets.bottom == 0 ? CustomButton(
              child: const Text('Register', style: TextStyle(color: Colors.black),),
              onPressed: () async {
                if(_emailController.text.isEmpty){
                  CustomSnackBar.showSnackBar(context, 'email cannot be empty');
                }
                else if(_emailController.text.length < 5 && !_emailController.text.contains('@nalsoft.net')){
                  CustomSnackBar.showSnackBar(context, 'email must contain @nalsoft.net');
                }
                else if(!Constants.empIDRegex.hasMatch(_empIdController.text) || _empIdController.text.length != 5 || _empIdController.text.isEmpty){
                  CustomSnackBar.showSnackBar(context, 'please enter your 5 digit employee id');
                }
                else if(_empIdController.text.isEmpty){
                  CustomSnackBar.showSnackBar(context, 'employee id cannot be empty');
                }
                else if(_confirmPasswordController.text.isEmpty){
                  CustomSnackBar.showSnackBar(context, 'password cannot be empty');
                }
                else if(_confirmPasswordController.text.length<10){
                  CustomSnackBar.showSnackBar(context, 'password must be atleast 10 characters');
                }
                else if(!Constants.regex.hasMatch(_confirmPasswordController.text)){
                  CustomSnackBar.showSnackBar(context, 'password must include atleast one special symbol, lowercase and uppercase letter');
                }
                else if(_createPasswordController.text != _confirmPasswordController.text){
                  CustomSnackBar.showSnackBar(context, 'passwords must match');
                }
                else if(department == 'Select Department' || floor == 'Select Floor'){
                  CustomSnackBar.showSnackBar(context, 'please select your department and floor');
                }
                else{
                  _signUp(context);
                }
              },
            ) : const SizedBox(),
            MediaQuery.of(context).viewInsets.bottom == 0 ? Image.asset('assets/images/food_png.png') : SizedBox(),
          ],
        )
    );
  }

  void _signUp(context) async{

    String email = _emailController.text.trim().toLowerCase();
    String password = _confirmPasswordController.text.trim();

    User? user = await _auth.signUpwithEmailandPassword(email, password);

    if(user!=null){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have successfully registered'))
      );
      final user = UserModel(email, _empIdController.text.trim(), password, department, floor);
      _db.createUser(user);
      Navigator.pushNamed(context, '/emp_homepage');
    }
  }
}

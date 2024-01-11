import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:meals_management/providers/login_provider.dart';
import 'package:meals_management/providers/user_signup_provider.dart';
import 'package:meals_management/services/database_service.dart';
import 'package:meals_management/services/user_authentication.dart';
import 'package:meals_management/utils/constants.dart';
import 'package:meals_management/views/models/user_model.dart';
import 'package:meals_management/views/screens/route_management.dart';
import 'package:meals_management/views/widgets/custom_button.dart';
import 'package:meals_management/views/widgets/custom_snackBar.dart';
import 'package:meals_management/views/widgets/cutom_dropdown.dart';
import 'package:meals_management/views/widgets/cutom_textField.dart';
import 'package:meals_management/views/widgets/resuable_widgets.dart';
import 'package:provider/provider.dart';
// import 'login_view.dart';

class UserRegistrationView extends StatefulWidget {
  @override
  State<UserRegistrationView> createState() => _UserRegistrationViewState();
}

class _UserRegistrationViewState extends State<UserRegistrationView> {
  Widgets reusableWidgets = Widgets();
  FirebaseAuthService _auth = FirebaseAuthService();
  DatebaseServices _dbsservice= DatebaseServices();

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _empIdController = TextEditingController();

  final _deptController = TextEditingController();

  final _floorController = TextEditingController();

  final _createPasswordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();
 List<dynamic> deptList = [];
  List<String> floorList = [];
@override
void initState() {
    // TODO: implement initState
    super.initState();
getDeptandFloorsList();
  }
    getDeptandFloorsList() async {
    final depts = await _dbsservice.readDepartments();
    final floors = await _dbsservice.readFloors();
    setState(() {
      deptList = depts.values.toList();
      floorList = floors;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
Provider.of<SignUpProvider>(context, listen: false).setDeptandFloorList();
   return Scaffold(
      backgroundColor: Colors.white,
        body: Column(
          children: [
            RotatedBox(
              quarterTurns: 2,
              child: Image.asset('assets/images/food.png'),
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
                            SizedBox(height: size.height*0.02,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Form(
                                key: _formKey,
                                  child: Column(
                                    children: [
                                      CustomTextField(controller: _usernameController,hintText: 'username', prefixIcon: Icon(Icons.person),),
                                      SizedBox(height: size.height*0.018,),
                                      CustomTextField(controller: _emailController,hintText: 'email', prefixIcon: Icon(Icons.person),),
                                      SizedBox(height: size.height*0.018,),
                                      CustomTextField(controller: _empIdController,hintText: 'employee id', prefixIcon: Icon(Icons.person),),
                                      SizedBox(height: size.height*0.018,),
                                      Consumer<LoginProvider>(
                                          builder: (context, provider, _) {
                                            return CustomTextField(hintText: 'create password',
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
                                      SizedBox(height: size.height*0.018,),
                                      Consumer<LoginProvider>(
                                          builder: (context, provider, _) {
                                            return CustomTextField(hintText: 'confirm password',
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
                                      SizedBox(height: size.height*0.018,),
                                      Row(
                                        children: [
                                          Consumer<SignUpProvider>(
                                            builder: (context, provider, child) {
                                              return Expanded(
                                                child: CustomDropDown(
                                                  hint: Text('Department',),
                                                  value: provider.getDept,
                                                  items: deptList.map<DropdownMenuItem<String>>(
                                                        (value) => DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value,style: TextStyle(fontSize: 12),),
                                                    ),
                                                  ).toList(),
                                                  onChanged: (String? newValue) {
                                                    provider.setDept(newValue!);
                                                  },
                                                  menuMaxHeight: size.height*0.5,
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(width: size.width*0.02,),
                                          Consumer<SignUpProvider>(
                                            builder: (context, provider, child) {
                                              return CustomDropDown(
                                                hint: Text('Floor',),
                                                value: provider.getFloor,
                                                items: floorList.map<DropdownMenuItem<String>>(
                                                      (value) => DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value,style: TextStyle(fontSize: 12),),
                                                    alignment: Alignment.center,
                                                  ),
                                                ).toList(),
                                                onChanged: (String? newValue) {
                                                  provider.setFloor(newValue!);
                                                },
                                                menuMaxHeight: size.height*0.5,
                                              );
                                            },
                                          ),
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
                if(_usernameController.text.isEmpty){
                  CustomSnackBar.showSnackBar(context, 'username cannot be empty');
                }
                else if(_emailController.text.isEmpty){
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
                else if(Provider.of<SignUpProvider>(context, listen: false).getDept == null || Provider.of<SignUpProvider>(context, listen: false).getFloor == null){
                  CustomSnackBar.showSnackBar(context, 'please select your department and floor');
                }
                else {
                  var isSuccess = await Provider.of<SignUpProvider>(context, listen: false).signUpUser(_usernameController.text, _emailController.text.trim(), _empIdController.text.trim(), _confirmPasswordController.text);
                  if(isSuccess){
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('You have successfully registered'))
                    );
                    Navigator.pushNamed(context, RouteManagement.userHomePage);
                  }else{
                    print('some error occurred');
                  }
                }
              },
              color: MaterialStatePropertyAll(Colors.grey.shade300),
            ) : const SizedBox(),
            MediaQuery.of(context).viewInsets.bottom == 0 ? Image.asset('assets/images/food.png') : SizedBox(),
          ],
        )
    );
  }
}

  // void _signUp(context,provider) async {
  //   String email = _emailController.text.trim();
  //   String password = _createPasswordController.text.trim();
  //   print("${email}${password}");
  //     bool onSuccessfulRegistration =await provider.signUpUser(email,_usernameController.text, _empIdController.text.trim(), password, _deptController.text, _floorController.text); 
      
  //   if (onSuccessfulRegistration){
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('You have successfully registered')));
  //     Navigator.pushNamed(context, RouteManagement.userHomePage);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('User already exists'),
  //         action: SnackBarAction(
  //             label: "Login",
  //             onPressed: () {
  //               Navigator.pop(context);
  //             })));
  //   }
  // }


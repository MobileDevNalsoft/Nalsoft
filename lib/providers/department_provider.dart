import 'package:flutter/material.dart';
import 'package:meals_management/Repositories/admin_repo.dart';
import 'package:meals_management/views/models/dept_model.dart';

class DeptProvider extends ChangeNotifier{

 Department _dept=Department(departments: []);
AdminRepo _adminRepo=AdminRepo();
Department get dept=>_dept;

updateDepartments() async{
 _dept=await _adminRepo.getDepartments();
 notifyListeners();
}


}

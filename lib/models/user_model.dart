class UserModel {
  int? responseCode;
  String? responseMessage;
  User? data;

  UserModel({this.responseCode, this.responseMessage, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    data = json['data'] != null ? new User.fromJson(json['data']) : null;
  }
}

class User {
  String? empId;
  String? empName;
  String? userName;
  String? userType;

  User({this.empId, this.empName, this.userName, this.userType});

  User.fromJson(Map<String, dynamic> json) {
    empId = json['emp_id'];
    empName = json['emp_name'];
    userName = json['user_name'];
    userType = json['user_type'];
  }
}

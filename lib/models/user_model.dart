class UserModel {
  int? responseCode;
  String? responseMessage;
  Data? data;

  UserModel({this.responseCode, this.responseMessage, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    if (json['data'] != null) {
      data = json['data'] != null ? new Data.fromJson(json['data']) : null;
     
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['response_message'] = this.responseMessage;
   if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? empId;
  String? empName;
  String? userName;
  String? status;
  String? info;
  String? department;
  String? userType;

  Data(
      {this.empId,
      this.empName,
      this.userName,
      this.status,
      this.info,
      this.department,
      this.userType});

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['emp_id'];
    empName = json['emp_name'];
    userName = json['user_name'];
    status = json['status'];
    info = json['info'];
    department = json['Department'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_id'] = this.empId;
    data['emp_name'] = this.empName;
    data['user_name'] = this.userName;
    data['status'] = this.status;
    data['info'] = this.info;
    data['Department'] = this.department;
    data['user_type'] = this.userType;
    return data;
  }
}
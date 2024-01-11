class Department {
  List<dynamic>? departments;

  Department({this.departments});

  Department.fromJson(Map<String, dynamic> json) {
    // departments = json['departments'].cast<String>();
    // return Department( departments: json.values.toList() as List<String>);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['departments'] = this.departments;
    return data;
  }
}

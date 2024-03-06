class UserEventsModel {
  int? responseCode;
  String? responseMessage;
  UserEvents? data;

  UserEventsModel({this.responseCode, this.responseMessage, this.data});

  UserEventsModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    data = json['data'] != null ? new UserEvents.fromJson(json['data']) : null;
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

class UserEvents {
  String? empId;
  List<Dates>? optedDates;
  List<Dates>? notOpted;

  UserEvents({this.empId, this.optedDates, this.notOpted});

  UserEvents.fromJson(Map<String, dynamic> json) {
    empId = json['emp_id'];
    if (json['opted_dates'] != null) {
      optedDates = <Dates>[];
      json['opted_dates'].forEach((v) {
        optedDates!.add(new Dates.fromJson(v));
      });
    }
    if (json['not_opted'] != null) {
      notOpted = <Dates>[];
      json['not_opted'].forEach((v) {
        notOpted!.add(new Dates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_id'] = this.empId;
    if (this.optedDates != null) {
      data['opted_dates'] = this.optedDates!.map((v) => v.toJson()).toList();
    }
    if (this.notOpted != null) {
      data['not_opted'] = this.notOpted!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dates {
  String? date;
  String? info;

  Dates({this.date, this.info});

  Dates.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['info'] = this.info;
    return data;
  }
}

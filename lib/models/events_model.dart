class EventsModel {
  List<DateTime>? opted;
  List<DateTime>? notOpted;
  List<DateTime>? unSigned;

  EventsModel({this.opted, this.notOpted, this.unSigned});

  EventsModel.fromJson(Map<String, dynamic> json) {
    print(json);
    opted = json['opted'] != null
        ? List<DateTime>.from(
            (json['opted'] as List).map((date) => DateTime(date)))
        : [];
    print("added op");
    notOpted = json['notOpted'] != null
        ? List<DateTime>.from((json['notOpted'] as List)
            .map((dynamic date) => DateTime.parse(date)))
        : [];

    unSigned = json['unSigned'] != null
        ? List<DateTime>.from((json['unSigned'] as List)
            .map((dynamic date) => DateTime.parse(date)))
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (opted != null) {
      data['opted'] =
          opted!.map((DateTime date) => date.toIso8601String()).toList();
    }
    if (notOpted != null) {
      data['notOpted'] =
          notOpted!.map((DateTime date) => date.toIso8601String()).toList();
    }
    if (unSigned != null) {
      data['unSigned'] =
          unSigned!.map((DateTime date) => date.toIso8601String()).toList();
    }
    return data;
  }
}

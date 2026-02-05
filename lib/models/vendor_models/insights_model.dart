class InsightsModel {
  bool? status;
  String? message;
  CountRetrieved? countRetrieved;
  List<Graphdata>? graphdata;

  InsightsModel(
      {this.status, this.message, this.countRetrieved, this.graphdata});

  InsightsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    countRetrieved = json['CountRetrieved'] != null
        ? CountRetrieved.fromJson(json['CountRetrieved'])
        : null;
    if (json['graphdata'] != null) {
      graphdata = <Graphdata>[];
      json['graphdata'].forEach((v) {
        graphdata!.add(Graphdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (countRetrieved != null) {
      data['CountRetrieved'] = countRetrieved!.toJson();
    }
    if (graphdata != null) {
      data['graphdata'] = graphdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountRetrieved {
  int? storevisits;
  int? storelikes;
  int? leads;

  CountRetrieved({this.storevisits, this.storelikes, this.leads});

  CountRetrieved.fromJson(Map<String, dynamic> json) {
    storevisits = json['storevisits'];
    storelikes = json['storelikes'];
    leads = json['leads'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['storevisits'] = storevisits;
    data['storelikes'] = storelikes;
    data['leads'] = leads;
    return data;
  }
}

class Graphdata {
  String? date;
  int? userVisits;

  Graphdata({this.date, this.userVisits});

  Graphdata.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    userVisits = json['user_visits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['user_visits'] = userVisits;
    return data;
  }
}

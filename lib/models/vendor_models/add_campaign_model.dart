class AddCamoaignModel {
  bool? status;
  String? message;
  Campaign? campaign;

  AddCamoaignModel({this.status, this.message, this.campaign});

  AddCamoaignModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    campaign =
        json['campaign'] != null ? Campaign.fromJson(json['campaign']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (campaign != null) {
      data['campaign'] = campaign!.toJson();
    }
    return data;
  }
}

class Campaign {
  String? vendorId;
  String? serviceId;
  String? campaignName;
  String? address;
  String? lat;
  String? lon;
  String? areaDistance;
  String? updatedAt;
  String? createdAt;
  int? id;

  Campaign(
      {this.vendorId,
      this.serviceId,
      this.campaignName,
      this.address,
      this.lat,
      this.lon,
      this.areaDistance,
      this.updatedAt,
      this.createdAt,
      this.id});

  Campaign.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendor_id'];
    serviceId = json['service_id'];
    campaignName = json['campaign_name'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    areaDistance = json['area_distance'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendor_id'] = vendorId;
    data['service_id'] = serviceId;
    data['campaign_name'] = campaignName;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['area_distance'] = areaDistance;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}

class GetCampaignModel {
  bool? status;
  String? message;
  List<CampaignData>? campaignData;
  String? isPaymentStatus;

  GetCampaignModel({
    this.status,
    this.message,
    this.campaignData,
    this.isPaymentStatus,
  });

  GetCampaignModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['campaignData'] != null) {
      campaignData = <CampaignData>[];
      json['campaignData'].forEach((v) {
        campaignData!.add(CampaignData.fromJson(v));
      });
    }
    isPaymentStatus = json['is_payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (campaignData != null) {
      data['campaignData'] = campaignData!.map((v) => v.toJson()).toList();
    }
    data['is_payment_status'] = isPaymentStatus;
    return data;
  }
}

class CampaignData {
  int? id;
  int? vendorId;
  int? serviceId;
  String? campaignName;
  String? address;
  String? lat;
  String? lon;
  String? areaDistance;
  String? createdAt;
  String? updatedAt;
  List<Goals>? goals;

  CampaignData({
    this.id,
    this.vendorId,
    this.serviceId,
    this.campaignName,
    this.address,
    this.lat,
    this.lon,
    this.areaDistance,
    this.createdAt,
    this.updatedAt,
    this.goals,
  });

  CampaignData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    serviceId = json['service_id'];
    campaignName = json['campaign_name'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    areaDistance = json['area_distance'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['goals'] != null) {
      goals = <Goals>[];
      json['goals'].forEach((v) {
        goals!.add(Goals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['service_id'] = serviceId;
    data['campaign_name'] = campaignName;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['area_distance'] = areaDistance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (goals != null) {
      data['goals'] = goals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Goals {
  int? id;
  int? campaignId;
  String? startDate;
  String? endDate;
  String? days;
  String? price;
  int? status;
  String? createdAt;
  String? updatedAt;

  Goals({
    this.id,
    this.campaignId,
    this.startDate,
    this.endDate,
    this.days,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Goals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    campaignId = json['campaign_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    days = json['days'];
    price = json['price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['campaign_id'] = campaignId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['days'] = days;
    data['price'] = price;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

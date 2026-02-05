class ServiceListModel {
  bool? status;
  String? message;
  String? serviceName;
  List<ServiceList>? serviceList;

  ServiceListModel({
    this.status,
    this.message,
    this.serviceName,
    this.serviceList,
  });

  ServiceListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    serviceName = json['service_name'];
    if (json['ServiceList'] != null) {
      serviceList = <ServiceList>[];
      json['ServiceList'].forEach((v) {
        serviceList!.add(ServiceList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['service_name'] = serviceName;
    if (serviceList != null) {
      data['ServiceList'] = serviceList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceList {
  int? id;
  String? storeName;
  String? storeDescription;
  String? price;
  int? subcategoryId;
  List<StoreImages>? storeImages;
  List<StoreAttachments>? storeAttachments;
  String? subcategoryName;
  VendorDetails? vendorDetails;

  ServiceList({
    this.id,
    this.storeName,
    this.storeDescription,
    this.price,
    this.subcategoryId,
    this.storeImages,
    this.storeAttachments,
    this.subcategoryName,
    this.vendorDetails,
  });

  ServiceList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['store_name'];
    storeDescription = json['store_description'];
    price = json['price'];
    subcategoryId = json['subcategory_id'];
    if (json['store_attachments'] != null) {
      storeImages = <StoreImages>[];
      json['store_images'].forEach((v) {
        storeImages!.add(StoreImages.fromJson(v));
      });
    }
    if (json['store_attachments'] != null) {
      storeAttachments = <StoreAttachments>[];
      json['store_attachments'].forEach((v) {
        storeAttachments!.add(StoreAttachments.fromJson(v));
      });
    }
    subcategoryName = json['subcategory_name'];
    vendorDetails =
        json['vendor_details'] != null
            ? VendorDetails.fromJson(json['vendor_details'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['store_name'] = storeName;
    data['store_description'] = storeDescription;
    data['price'] = price;
    data['subcategory_id'] = subcategoryId;
    if (storeImages != null) {
      data['store_images'] = storeImages!.map((v) => v.toJson()).toList();
    }
    if (storeAttachments != null) {
      data['store_attachments'] =
          storeAttachments!.map((v) => v.toJson()).toList();
    }
    data['subcategory_name'] = subcategoryName;
    if (vendorDetails != null) {
      data['vendor_details'] = vendorDetails!.toJson();
    }
    return data;
  }
}

class StoreImages {
  int? id;
  String? url;

  StoreImages({this.id, this.url});

  StoreImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}

class StoreAttachments {
  int? id;
  String? url;

  StoreAttachments({this.id, this.url});

  StoreAttachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}

class VendorDetails {
  String? firstName;
  String? lastName;
  String? email;
  String? image;

  VendorDetails({this.firstName, this.lastName, this.email, this.image});

  VendorDetails.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['image'] = image;
    return data;
  }
}

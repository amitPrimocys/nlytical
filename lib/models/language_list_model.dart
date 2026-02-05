class LanguageListModel {
  bool? success;
  String? message;
  List<Languages>? languages;

  LanguageListModel({this.success, this.message, this.languages});

  LanguageListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages!.add(Languages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Languages {
  String? language;
  int? status;
  int? defaultStatus;
  int? statusId;
  String? country;
  String? languageAlignment;

  Languages({
    this.language,
    this.status,
    this.defaultStatus,
    this.statusId,
    this.country,
    this.languageAlignment,
  });

  Languages.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    status = json['status'];
    defaultStatus = json['default_status'];
    statusId = json['status_id'];
    country = json['country'];
    languageAlignment = json['language_alignment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language'] = language;
    data['status'] = status;
    data['default_status'] = defaultStatus;
    data['status_id'] = statusId;
    data['country'] = country;
    data['language_alignment'] = languageAlignment;
    return data;
  }
}

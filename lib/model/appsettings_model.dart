// To parse this JSON data, do
//
//     final appSettingModel = appSettingModelFromJson(jsonString);

import 'dart:convert';

List<AppSettingModel> appSettingModelFromJson(String str) => List<AppSettingModel>.from(json.decode(str).map((x) => AppSettingModel.fromJson(x)));

String appSettingModelToJson(List<AppSettingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppSettingModel {
  int? id;
  String? key;
  String? value;
  int? addedBy;
  int? modifiedBy;
  DateTime? modifiedOn;
  DateTime? addedOn;
  String? submittedBy;
  String? lstModifiedBy;

  AppSettingModel({
    this.id,
    this.key,
    this.value,
    this.addedBy,
    this.modifiedBy,
    this.modifiedOn,
    this.addedOn,
    this.submittedBy,
    this.lstModifiedBy,
  });

  AppSettingModel copyWith({
    int? id,
    String? key,
    String? value,
    int? addedBy,
    int? modifiedBy,
    DateTime? modifiedOn,
    DateTime? addedOn,
    String? submittedBy,
    String? lstModifiedBy,
  }) =>
      AppSettingModel(
        id: id ?? this.id,
        key: key ?? this.key,
        value: value ?? this.value,
        addedBy: addedBy ?? this.addedBy,
        modifiedBy: modifiedBy ?? this.modifiedBy,
        modifiedOn: modifiedOn ?? this.modifiedOn,
        addedOn: addedOn ?? this.addedOn,
        submittedBy: submittedBy ?? this.submittedBy,
        lstModifiedBy: lstModifiedBy ?? this.lstModifiedBy,
      );

  factory AppSettingModel.fromJson(Map<String, dynamic> json) => AppSettingModel(
    id: json["id"],
    key: json["key"],
    value: json["value"],
    addedBy: json["addedBy"],
    modifiedBy: json["modifiedBy"],
    modifiedOn: json["modifiedOn"] == null ? null : DateTime.parse(json["modifiedOn"]),
    addedOn: json["addedOn"] == null ? null : DateTime.parse(json["addedOn"]),
    submittedBy: json["submittedBy"],
    lstModifiedBy: json["lstModifiedBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "key": key,
    "value": value,
    "addedBy": addedBy,
    "modifiedBy": modifiedBy,
    "modifiedOn": modifiedOn?.toIso8601String(),
    "addedOn": addedOn?.toIso8601String(),
    "submittedBy": submittedBy,
    "lstModifiedBy": lstModifiedBy,
  };
}

// To parse this JSON data, do
//
//     final subAsset = subAssetFromJson(jsonString);

import 'dart:convert';

SubAsset subAssetFromJson(String str) => SubAsset.fromJson(json.decode(str));

String subAssetToJson(SubAsset data) => json.encode(data.toJson());

class SubAsset {
  SubAsset({
    this.subId,
    this.subIdAsset,
    this.subIdUser,
    this.subName,
    this.subVendor,
    this.subValue,
    this.assetId,
    this.assetName,
    this.assetIcon,
    this.assetColor,
  });

  int subId;
  int subIdAsset;
  int subIdUser;
  String subName;
  String subVendor;
  int subValue;
  int assetId;
  String assetName;
  String assetIcon;
  String assetColor;

  factory SubAsset.fromJson(Map<String, dynamic> json) => SubAsset(
    subId: json["sub_id"],
    subIdAsset: json["sub_id_asset"],
    subIdUser: json["sub_id_user"],
    subName: json["sub_name"],
    subVendor: json["sub_vendor"],
    subValue: json["sub_value"],
    assetId: json["asset_id"],
    assetName: json["asset_name"],
    assetIcon: json["asset_icon"],
    assetColor: json["asset_color"],
  );

  Map<String, dynamic> toJson() => {
    "sub_id": subId,
    "sub_id_asset": subIdAsset,
    "sub_id_user": subIdUser,
    "sub_name": subName,
    "sub_vendor": subVendor,
    "sub_value": subValue,
    "asset_id": assetId,
    "asset_name": assetName,
    "asset_icon": assetIcon,
    "asset_color": assetColor,
  };
}

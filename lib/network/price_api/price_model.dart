import 'dart:convert';
import 'package:flutter/cupertino.dart';

class PriceModel {
  ///預設正確情況
  String? code;
  String? message;
  String? messageDetail;
  List<CurrencyData>? data;
  bool? success;

  PriceModel(
      {this.code, this.message, this.messageDetail, this.data, this.success});

  PriceModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    messageDetail = json['messageDetail'];
    if (json['data'] != null) {
      data = <CurrencyData>[];
      json['data'].forEach((v) {
        data!.add(CurrencyData.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['message'] = message;
    data['messageDetail'] = messageDetail;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  reset() {
    code = '000000';
    message = null;
    messageDetail = null;
    success = true;
  }

  setValue(Map<String, dynamic> json) {
    ///有錯誤才覆蓋
    if (json['code'] != code ||
        json['message'] != null ||
        json['messageDetail'] != null ||
        json['success'] != true) {
      debugPrint('error');
      code = json['code'];
      message = json['message'];
      messageDetail = json['messageDetail'];
      success = json['success'];
    } else {
      return;
    }
  }
}

class CurrencyData {
  String? asset;
  String? currency;
  double? referenceBuyPrice;
  double? referenceSellPrice;

  CurrencyData({
    this.asset,
    this.currency,
  });

  setReferencePrice(double? price, bool isBuy, String fromJsonCurrency) {
    if (isBuy) {
      referenceBuyPrice = price;
    } else {
      referenceSellPrice = price;
    }
    currency = fromJsonCurrency;
  }

  CurrencyData.fromJson(Map<String, dynamic> json) {
    asset = json['asset'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['asset'] = asset;
    data['currency'] = currency;
    data['referenceBuyPrice'] = referenceBuyPrice;
    data['referenceSellPrice'] = referenceSellPrice;
    return data;
  }
}

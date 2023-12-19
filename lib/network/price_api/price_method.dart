import 'package:crypto_exchange/data/list_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'price_model.dart';

class PriceMethod with ChangeNotifier {
  late final List<PriceModel> _priceList;

  PriceMethod(this._priceList);

  List<CurrencyData> get priceList {
    final List<CurrencyData> list = [];
    for (var e in cryptos) {
      {
        for (PriceModel model in _priceList) {
          if (model.data!.first.asset == e) list.add(model.data!.first);
        }
      }
    }
    return list;
  }

  Future getAllPrice(String selectedCurrency) async {
    for (var model in _priceList) {
      Future.wait([
        callAPI(model, selectedCurrency, true),
        callAPI(model, selectedCurrency, false),
      ]);
    }
  }

  Future callAPI(
    PriceModel model,
    String selectedCurrency,
    bool isBuy,
  ) async {
    late http.Response res;
    try {
      res = await http.post(
        Uri.parse(
            'https://c2c.binance.com/bapi/c2c/v2/public/c2c/adv/quoted-price'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          "assets": [model.data!.first.asset],
          "fiatCurrency": selectedCurrency,
          "tradeType": isBuy ? "BUY" : "SELL",
          "fromUserRole": "USER",
        }),
      );

      var content = jsonDecode(res.body) as Map<String, dynamic>;
      model.reset();
      model.setValue(content);
      model.data!.first.setReferencePrice(
        checkDouble(content['data'][0]['referencePrice']),
        isBuy,
        content['data'][0]['currency'],
      );

      notifyListeners();
    } on Exception catch (err) {
      model.data!.first.currency = selectedCurrency;
      model.data!.first.referenceBuyPrice = -1;
      model.data!.first.referenceSellPrice = -1;

      notifyListeners();
    }
  }

  double checkDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    return -1;
  }
}

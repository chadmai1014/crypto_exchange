import 'package:crypto_exchange/network/price_api/price_model.dart';
import 'package:crypto_exchange/pages/index_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'data/list_data.dart';
import 'network/price_api/price_method.dart';

void main() {
  runApp(
    ///Provider
    ChangeNotifierProvider(
      create: (context) {
        ///1. 將PriceModel.dart 的 asset 賦值
        final List<PriceModel> list = cryptos
            .map((e) => PriceModel(data: [
                  CurrencyData(asset: e),
                ]))
            .toList();

        ///傳值
        return PriceMethod(list);
      },
      child: const CupertinoApp(
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        home: IndexPage(),
      ),
    ),
  );
}

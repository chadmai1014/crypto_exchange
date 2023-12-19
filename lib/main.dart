import 'package:crypto_exchange/network/price_api/price_model.dart';
import 'package:crypto_exchange/pages/index_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'data/list_data.dart';
import 'network/price_api/price_method.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => PriceMethod(cryptos
                .map((e) => PriceModel(data: [
                      CurrencyData(asset: e),
                    ]))
                .toList())),
      ],
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

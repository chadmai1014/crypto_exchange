import 'dart:async';
import 'package:crypto_exchange/data/list_data.dart';
import 'package:crypto_exchange/network/price_api/price_method.dart';
import 'package:crypto_exchange/pages/calculator_page.dart';
import 'package:crypto_exchange/widgets/dropdown_select.dart' as d;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../widgets/dropdown.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List<DropdownMenuItem<String>> dropdownItems = [];
  String _selectedCurrency = currencies.first;
  Timer? _timer;
  Duration myDuration = Duration(seconds: 10);

  late PriceMethod _priceMethod;

  String strDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void reset() {
    _timer!.cancel();
    _priceMethod.getAllPrice(this._selectedCurrency);
    setState(() {
      myDuration = const Duration(seconds: 10);
    });
  }

  void setCountDown() {
    setState(() {
      final s = myDuration.inSeconds - 1;
      if (s < 0) {
        reset();
        start();
      } else {
        myDuration = Duration(seconds: s);
      }
    });
  }

  @override
  void initState() {
    dropdownItems = List.generate(
      currencies.length,
      (index) => DropdownMenuItem(
        alignment: Alignment.center,
        value: currencies[index],
        child: Text(
          currencies[index],
          textAlign: TextAlign.center,
        ),
      ),
    );

    _priceMethod = Provider.of<PriceMethod>(context, listen: false);
    _priceMethod.getAllPrice(_selectedCurrency).then((value) => start());
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey,
      navigationBar: getNavigationBar(),
      child: getListView(),
    );
  }

  ObstructingPreferredSizeWidget getNavigationBar() {
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return CupertinoNavigationBar(
      backgroundColor: CupertinoColors.black.withOpacity(.4),
      middle: d.DropDownSelect(
          value: _selectedCurrency,
          items: dropdownItems,
          onChanged: (value) {
            setState(() {
              _selectedCurrency = value;
            });
            setState(() {
              _priceMethod.getAllPrice(_selectedCurrency);
            });
          }),
      trailing: SizedBox(
        width: 80,
        child: CupertinoButton(
          onPressed: () {
            reset();
            start();
            setState(() {
              _priceMethod.getAllPrice(this._selectedCurrency);
            });
          },
          padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.refresh_thin,
                color: CupertinoColors.white,
              ),
              SizedBox(width: 5),
              Text(
                '$minutes: $seconds',
                style: TextStyle(
                  color: CupertinoColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getListView() {
    var _screenHeight = MediaQuery.of(context).size.height - 97;
    var _screenWidth = MediaQuery.of(context).size.width;
    return Consumer<PriceMethod>(
      builder: (cxt, priceMethod, child) {
        return ListView.builder(
          physics: const ClampingScrollPhysics(),
          itemExtent: _screenHeight / 9,
          padding: EdgeInsets.only(top: 97),
          itemCount: priceMethod.priceList.length,
          itemBuilder: (BuildContext context, int index) {
            return CupertinoButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => CalculatorPage(
                        currency: priceMethod.priceList[index].currency!,
                        cryptoCoin: priceMethod.priceList[index].asset!,
                        buyPrice:
                            priceMethod.priceList[index].referenceSellPrice!,
                        sellPrice:
                            priceMethod.priceList[index].referenceBuyPrice!),
                  ),
                );
              },
              color: CupertinoColors.black.withOpacity(.7),
              borderRadius: BorderRadius.circular(0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  ///虛擬貨幣的title
                  Text(
                    priceMethod.priceList[index].asset!,
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 22,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    ///買入賣出的欄位寬度
                    width: _screenWidth / 4 * 3,
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              '買入：',
                              style: TextStyle(
                                color: CupertinoColors.systemGreen,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: .5,
                            ),
                            Text(
                              priceMethod.priceList[index].referenceSellPrice
                                  .toString(),
                              style: TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        SizedBox(
                          ///賣出的欄位寬度
                          width: _screenWidth / 17 * 6.5,
                          child: Row(
                            children: [
                              Text(
                                '賣出：',
                                style: TextStyle(
                                  color: CupertinoColors.systemRed,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                width: .5,
                              ),
                              Text(
                                priceMethod.priceList[index].referenceBuyPrice
                                    .toString(),
                                style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

import 'dart:async';
import 'package:crypto_exchange/pages/index_page.dart';
import 'package:crypto_exchange/widgets/converter_card.dart';
import 'package:flutter/cupertino.dart';

class CalculatorPage extends StatefulWidget {
  final String currency;
  final String cryptoCoin;
  final double buyPrice;
  final double sellPrice;
  final int index;

  const CalculatorPage({
    super.key,
    required this.buyPrice,
    required this.sellPrice,
    required this.currency,
    required this.cryptoCoin,
    required this.index,
  });

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  late StreamSubscription priceListSubscription;
  late TextEditingController upController = TextEditingController();
  late TextEditingController downController = TextEditingController();
  bool isReverse = false;
  bool isBuy = true;

  late double realBuyPrice = widget.buyPrice;
  late double realSellPrice = widget.sellPrice;

  String getReference(String fromControllerText) {
    ///買入
    if (isBuy == true) {
      return !isReverse
          ?

          ///法幣 to 虛幣
          ((double.tryParse(fromControllerText) ?? 0) / realBuyPrice).toString()
          :

          ///虛幣 to 法幣
          ((double.tryParse(fromControllerText) ?? 0) * realBuyPrice)
              .toString();
    }

    ///賣出
    else {
      return !isReverse
          ?

          ///法幣 to 虛幣
          ((double.tryParse(fromControllerText) ?? 0) / realBuyPrice).toString()
          :

          ///虛幣 to 法幣
          ((double.tryParse(fromControllerText) ?? 0) * realBuyPrice)
              .toString();
    }
  }

  @override
  void initState() {
    super.initState();

    priceListSubscription = streamController.stream.listen((list) {
      debugPrint("widget.buyPrice= ${widget.buyPrice}");
      debugPrint("widget.sellPrice= ${widget.sellPrice}");
      setState(() {
        debugPrint("new buyPrice=${list[widget.index].referenceSellPrice!}");
        debugPrint("new sellPrice=${list[widget.index].referenceBuyPrice!}");
        realBuyPrice = list[widget.index].referenceSellPrice!;
        realSellPrice = list[widget.index].referenceBuyPrice!;
      });
    });
  }

  @override
  void dispose() {
    upController.dispose();
    downController.dispose();
    priceListSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: const CupertinoNavigationBar(
        border: null,
        backgroundColor: CupertinoColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 30, left: 30),
        child: Column(
          children: [
            ConverterCard(
                onChanged: (val) {
                  downController.text = getReference(val);
                },
                title: !isReverse ? widget.currency : widget.cryptoCoin,
                readOnly: false,
                controller: upController),
            const SizedBox(height: 50),
            Row(
              children: [
                Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3F51B5).withOpacity(.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      setState(() {
                        isBuy = !isBuy;
                      });
                      downController.text = getReference(upController.text);
                    },
                    padding: EdgeInsets.all(0),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.arrow_2_circlepath,
                            color: CupertinoColors.black,
                            size: 18,
                          ),
                          Text(
                            isBuy ? "買" : "賣",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              color: CupertinoColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3F51B5).withOpacity(.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      (isBuy)
                          ? realBuyPrice.toString()
                          : realSellPrice.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EAF6),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xFF3F51B5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.arrow_up_arrow_down,
                        size: 30,
                        color: Color(0xFF8C9EFF),
                      ),
                      SizedBox(width: 15),
                      CupertinoButton(
                        onPressed: () {
                          String tempString;
                          tempString = upController.text.toString();
                          upController.text = downController.text;
                          downController.text = tempString;

                          setState(() {
                            isReverse = !isReverse;
                          });
                        },
                        padding: EdgeInsets.all(0),
                        child: Text(
                          "SWITCH",
                          style: TextStyle(
                            color: Color(0xFF3F51B5),
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            ConverterCard(
                onChanged: (_) {},
                title: !isReverse ? widget.cryptoCoin : widget.currency,
                readOnly: true,
                controller: downController),
          ],
        ),
      ),
    );
  }
}

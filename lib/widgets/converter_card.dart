import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ConverterCard extends StatefulWidget {
  final TextEditingController? controller;
  final bool readOnly;
  final String title;
  final ValueChanged onChanged;

  const ConverterCard({
    super.key,
    required this.title,
    required this.readOnly,
    this.controller,
    required this.onChanged,
  });

  @override
  State<ConverterCard> createState() => _ConverterCardState();
}

class _ConverterCardState extends State<ConverterCard> {
  @override
  Widget build(BuildContext context) {
    var sh = MediaQuery.of(context).size.height;
    return Container(
      height: (sh - 100) / 4,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3F51B5).withOpacity(.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: CupertinoColors.black,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            CupertinoTextField.borderless(
              onChanged: widget.onChanged,
              controller: widget.controller,
              readOnly: widget.readOnly,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: CupertinoColors.systemGrey5),
                ),
              ),
              placeholder: '0.0',
              suffix: const Text(
                '\$',
                style:
                    TextStyle(fontSize: 20, color: CupertinoColors.systemGrey),
              ),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}

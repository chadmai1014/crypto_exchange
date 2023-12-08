import 'package:crypto_exchange/widgets/dropdown.dart' as d;
import 'package:flutter/material.dart';

class DropDownSelect extends StatelessWidget {
  final String value;
  final List<d.DropdownMenuItem> items;
  final ValueChanged onChanged;

  const DropDownSelect({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 50, right: 50),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white10,
            width: 0.5,
          ),
        ),
      ),
      child: Material(
        child: d.DropdownButton(
          icon: const Icon(
            Icons.arrow_downward,
            color: Colors.black26,
          ),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          underline: Container(),
          iconSize: 32,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          value: value,
        ),
      ),
    );
  }
}

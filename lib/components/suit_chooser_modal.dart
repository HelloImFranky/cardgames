import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/card_model.dart';

class _SuitOption {
  final Suit value;
  late Color color;
  late String label;

  _SuitOption({
    required this.value,
  }) {
    color = CardModel.suitToColor(value);
    label = CardModel.suitToUnicode(value);
  }
}

class SuitChooserModal extends StatelessWidget {
  const SuitChooserModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<_SuitOption> suits = [
      _SuitOption(value: Suit.clubs),
      _SuitOption(value: Suit.hearts),
      _SuitOption(value: Suit.spades),
      _SuitOption(value: Suit.diamonds),
    ];

    return AlertDialog(
      title: const Text("Choose Suit"),
      content: Row(
        children: suits
            .map((suit) => TextButton(
                onPressed: () {
                  Navigator.of(context).pop(suit.value);
                },
                child: Text(
                  suit.label,
                  style: TextStyle(color: suit.color, fontSize: 32),
                )))
            .toList(),
      ),
    );
  }
}

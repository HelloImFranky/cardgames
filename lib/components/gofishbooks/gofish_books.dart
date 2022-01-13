import 'dart:math';

import 'package:cardgames/components/playing_card.dart';
import 'package:cardgames/constants.dart';
import 'package:flutter/material.dart';

import '../../models/card_model.dart';
import '../../models/gofish_bookscollection_model.dart';

class GoFishBooks extends StatelessWidget {
  final List<CardModel> cards;
  final double size;

  const GoFishBooks({
    Key? key,
    required this.cards,
    this.size = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    int randomNumber = random.nextInt(100);
    int randomNumber2 = random.nextInt(100);
    return Container(
      width: CARD_WIDTH * size /3,
      height: CARD_HEIGHT /3,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45, width: 2),
      ),
      child: Stack(
        children: cards
            .map((card) => Positioned(
              top: randomNumber.toDouble(),
              bottom: randomNumber2.toDouble(),
              child: PlayingCard(
                    card: card,
                    visible: true,
                  ),
            ))
            .toList(),
      ),
    );
  }
}

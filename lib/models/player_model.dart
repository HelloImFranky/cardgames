import 'package:cardgames/models/card_model.dart';
import 'package:flutter/material.dart';

class PlayerModel {
  final String name;
  final bool isHuman;
  List<CardModel> cards;

  PlayerModel({
    required this.name,
    this.cards = const [],
    this.isHuman = false,
  });

  addCards(List<CardModel> newCards){
    cards = [...cards, ...newCards];
  }

  removeCard(CardModel card){
    cards.removeWhere((c) => c.value == card.value && c.suit == card.suit);
  }

  bool get isBot{
    return !isHuman;
  }

}

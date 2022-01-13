import 'dart:ui';

import 'package:flutter/material.dart';

enum Suit{
  hearts, clubs, diamonds, spades, other,
}

class CardModel {
  final String image;
  final String value;
  final Suit suit;

  CardModel({required this.image, required this.value, required this.suit,});

  factory CardModel.fromJson(Map<String, dynamic> json){
    return CardModel(image: json['image'], suit: stringToSuit(json['suit']), value: json['value']);
  }

  static Suit stringToSuit(String suit){
    switch(suit.toUpperCase().trim()){
      case "HEARTS":
        return Suit.hearts;
      case "CLUBS":
        return Suit.clubs;
      case "DIAMONDS":
        return Suit.diamonds;
      case "SPADES":
        return Suit.spades;
      default:
        return Suit.other;
    }
  }

  static String suitToString(Suit suit){
    switch(suit){
      case Suit.hearts:
        return "Hearts";
      case Suit.clubs:
        return "Clubs";
      case Suit.diamonds:
        return "Diamonds";
      case Suit.spades:
        return "Spades";
      default:
        return "Other";
    }
  }

  static String suitToUnicode(Suit suit){
    switch(suit){
      case Suit.hearts:
        return String.fromCharCode(0x2665);
      case Suit.clubs:
        return String.fromCharCode(0x2663);
      case Suit.diamonds:
        return String.fromCharCode(0x2666);
      case Suit.spades:
        return String.fromCharCode(0x2660);
      default:
        return "Other";
    }
  }

  static Color suitToColor(Suit suit){
    switch(suit){
      case Suit.hearts:
      case Suit.diamonds:
        return Colors.red;
      case Suit.clubs:
      case Suit.spades:
      case Suit.other:
        return Colors.black;
    }
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['value'] = value;
    data['suit'] = suit;
    return data;
  }
}
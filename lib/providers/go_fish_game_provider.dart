import 'package:cardgames/components/gofishbooks/gofish_books.dart';
import 'package:cardgames/components/suit_chooser_modal.dart';
import 'package:cardgames/constants.dart';
import 'package:cardgames/models/card_model.dart';
import 'package:cardgames/models/gofish_bookscollection_model.dart';
import 'package:cardgames/models/player_model.dart';
import 'package:cardgames/providers/game_provider.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class GoFishGameProvider extends GameProvider {
  List<CardModel> toRemove = [];
  List<CardModel> aBook = [];
  List<CardModel> num2Book = [];
  List<CardModel> num3Book = [];
  List<CardModel> num4Book = [];
  List<CardModel> num5Book = [];
  List<CardModel> num6Book = [];
  List<CardModel> num7Book = [];
  List<CardModel> num8Book = [];
  List<CardModel> num9Book = [];
  List<CardModel> num10Book = [];
  List<CardModel> suitJBook = [];
  List<CardModel> suitQBook = [];
  List<CardModel> suitKBook = [];

  List<CardModel> allBooks = [];
  bool foundCase = false;

  @override
  Future<void> setupBoard() async {
    for (var p in players) {
      await drawCards(p, count: 7, allowAnyTime: true);
    }
    turn.drawCount = 0;
    turn.actionCount = 0;
  }

  @override
  Future<void> playCard({
    required PlayerModel player,
    required CardModel card,
  }) async {
    if (!canPlayCard(card)) return;
    if (validChoice(turn.otherPlayer, card) == true) {
      /*
    Below is how cards from both player's cardlist is selected
    and added to array toRemove, then toRemove is used as
    a reference for which object to remove in player's cardlist
     */

      for (var p in players) {
        for (var c in p.cards) {
          if (c.value == card.value) {
            toRemove.add(c);
          }
        }
        p.cards.removeWhere((c) => toRemove.contains(c));
      }

      /*

    TODO: You are here! Two things do not work as expected
     first being the turn.acountCount and when a player can
     playCard again, as well as how the GoFishBooks is called
     on the gameboard.

     */

      if (toRemove.contains(card)) {
        turn.actionCount = 0;
        sendToBook(book: toRemove);
        showToast("The Opponent Had ${card.value}!, Play Again!");
        toRemove.clear();
      }
      else {
        turn.actionCount += 2;
      }

      notifyListeners();
    }
    else{
      return;
    }
  }

  Future<void> sendToBook({required List<CardModel> book}) async {
    book.map((c) => {
          if (c.value == "2")
            {num2Book.add(c)}
          else if (c.value == "3")
            {num3Book.add(c)}
          else if (c.value == "4")
            {num4Book.add(c)}
          else if (c.value == "5")
            {num5Book.add(c)}
          else if (c.value == "6")
            {num6Book.add(c)}
          else if (c.value == "7")
            {num7Book.add(c)}
          else if (c.value == "8")
            {num8Book.add(c)}
          else if (c.value == "9")
            {num9Book.add(c)}
          else if (c.value == "10")
            {num10Book.add(c)}
          else if (c.value == "JACK")
            {suitJBook.add(c)}
          else if (c.value == "QUEEN")
            {suitQBook.add(c)}
          else if (c.value == "KING")
            {suitKBook.add(c)}
          else if (c.value == "ACE")
            {aBook.add(c)}
        });
    // while (foundCase == false) {
    //   switch (book.first.value){
    //     case "2":
    //       num2Book.fishBooks = book;
    //       foundCase = true;
    //       break;
    //     case "3":
    //       num3Book.fishBooks = book;
    //       foundCase = true;
    //       break;
    //     case "4":
    //       num4Book.fishBooks = book;
    //       foundCase = true;
    //       break;
    //     case "5":
    //       num5Book.fishBooks = book;
    //       foundCase = true;
    //       break;
    //     case "6":
    //       num6Book.fishBooks = book;
    //       foundCase = true;
    //       break;
    //     case "7":
    //       num7Book.fishBooks = book;
    //       foundCase = true;
    //       break;
    //     case "8":
    //       num8Book.fishBooks = book;
    //       foundCase = true;
    //       break;
    //     case "9":
    //       num9Book.fishBooks = book;
    //       foundCase = true;
    //       break;
    //     case "10":
    //       num10Book.fishBooks = book;
    //       foundCase = true;
    //       break;
    //     case "JACK":
    //       suitJBook.fishBooks = book;
    //       foundCase = true;
    //       break;
    //     case "QUEEN":
    //       suitQBook.fishBooks = book;
    //       foundCase = true;
    //       break;
    //     case "KING":
    //       suitKBook.fishBooks = book;
    //       foundCase = true;
    //       break;
    //     case "ACE":
    //       aBook.fishBooks = book;
    //       foundCase = true;
    //       break;
    //   }
    // }


    notifyListeners();
  }

  List<CardModel> getAllBooks() {
    return allBooks = [
      ...aBook,
      ...num2Book,
      ...num3Book,
      ...num4Book,
      ...num5Book,
      ...num6Book,
      ...num7Book,
      ...num8Book,
      ...num9Book,
      ...num10Book,
      ...suitJBook,
      ...suitQBook,
      ...suitKBook
    ];
  }

  bool validChoice(PlayerModel otherPlayer, CardModel card) {
    return otherPlayer.cards.contains(card);
  }

  @override
  bool get canEndTurn {
    if (turn.drawCount > 0 || turn.actionCount > 0) {
      return true;
    }
    return false;
  }

  @override
  bool get gameIsOver {
    if (turn.currentPlayer.cards.isEmpty) {
      return true;
    }
    return false;
  }

  @override
  void finishGame() {
    showToast("Game Over ${turn.currentPlayer.name} WINS!");
    notifyListeners();
  }

  @override
  Future<void> botTurn() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final p = turn.currentPlayer;
    for (final c in p.cards) {
      if (validChoice(turn.otherPlayer, c)) {
        await playCard(player: p, card: c);
        endTurn();
        return;
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    await drawCards(p, count: 1, allowAnyTime: true);

    endTurn();
  }
}

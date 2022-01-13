import 'package:cardgames/components/suit_chooser_modal.dart';
import 'package:cardgames/constants.dart';
import 'package:cardgames/models/card_model.dart';
import 'package:cardgames/providers/game_provider.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/player_model.dart';

class CrazyEightsGameProvider extends GameProvider {
  @override
  Future<void> setupBoard() async {
    for (var p in players) {
      await drawCards(p, count: 8, allowAnyTime: true);
    }
    await drawCardToDiscardPile();

    setLastPlayed(discardTop!);

    turn.drawCount = 0;
    turn.actionCount = 0;
  }

  Future<void> playCard({
    required PlayerModel player,
    required CardModel card,
  }) async {
    if (!canPlayCard(card)) return;

    player.removeCard(card);

    discards.add(card);

    turn.actionCount += 1;

    setLastPlayed(card);

    await applyCardSideEffects(card);

    if (gameIsOver) {
      finishGame();
    }

    notifyListeners();
  }

  @override
  bool get canEndTurn {
    if (turn.drawCount > 0 || turn.actionCount > 0) {
      return true;
    }
    return false;
  }

  @override
  bool canPlayCard(CardModel card) {
    bool canPlay = false;

    if (gameState[GS_LAST_SUIT] == null || gameState[GS_LAST_VALUE] == null) {
      return false;
    }
    if (gameState[GS_LAST_SUIT] == card.suit) {
      canPlay = true;
    }
    if (gameState[GS_LAST_VALUE] == card.value) {
      canPlay = true;
    }
    if (card.value == "8") {
      canPlay = true;
    }

    return canPlay;
  }

  @override
  Future<void> applyCardSideEffects(CardModel card) async {
    if (card.value == "8") {
      Suit suit;

      if (turn.currentPlayer.isHuman) {
        suit = await showDialog(
            context: navigatorKey.currentContext!,
            builder: (_) => const SuitChooserModal(),
            barrierDismissible: false);
      } else {
        suit = turn.currentPlayer.cards.first.suit;
      }
      gameState[GS_LAST_SUIT] = suit;
      setTrump(suit);
      showToast("${turn.currentPlayer.name} has changed it to ${CardModel.suitToString(suit)}");
    } else if (card.value == "2") {
      await drawCards(turn.otherPlayer, count: 2, allowAnyTime: true);
      showToast("${turn.otherPlayer.name} has to draw 2 cards!");
    } else if (card.value == "QUEEN" && card.suit == Suit.spades) {
      await drawCards(turn.otherPlayer, count: 5, allowAnyTime: true);
      showToast("${turn.otherPlayer.name} has to draw 5 cards!");
    } else if (card.value == "JACK") {
      showToast("${turn.otherPlayer.name} misses a turn");
      skipTurn();
    }

    notifyListeners();
  }

  @override
  bool get gameIsOver{
    if(turn.currentPlayer.cards.isEmpty){
      return true;
    }
    return false;
  }

  @override
  void finishGame(){
    showToast("Game Over ${turn.currentPlayer.name} WINS!");
    notifyListeners();
  }

  @override
  Future<void> botTurn() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final p = turn.currentPlayer;
    for (final c in p.cards) {
      if (canPlayCard(c)) {
        await playCard(player: p, card: c);
        endTurn();
        return;
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));
    await drawCards(p);
    await Future.delayed(const Duration(milliseconds: 500));

    if (canPlayCard(p.cards.last)) {
      await playCard(player: p, card: p.cards.last);
    }
    endTurn();
  }
}

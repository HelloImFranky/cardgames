import 'package:cardgames/constants.dart';
import 'package:cardgames/main.dart';
import 'package:cardgames/models/player_model.dart';
import 'package:flutter/material.dart';

import '../models/card_model.dart';
import '../models/deck_model.dart';
import '../models/turns_model.dart';
import '../services/deck_service.dart';

abstract class GameProvider with ChangeNotifier {
  GameProvider() {
    _service = DeckService();
  }

  late DeckService _service;

  late Turn _turn;
  Turn get turn => _turn;

  DeckModel? _currentDeck;
  DeckModel? get currentDeck => _currentDeck;

  List<PlayerModel> _players = [];
  List<PlayerModel> get players => _players;

  List<CardModel> _discards = [];
  List<CardModel> get discards => _discards;


  CardModel? get discardTop => discards.isEmpty ? null : _discards.last;

  Map<String, dynamic> gameState = {};
  Widget? bottomWidget;

  Future<void> newGame(List<PlayerModel> players) async {
    final deck = await _service.newDeck(1);
    _currentDeck = deck;
    _players = players;
    _discards = [];
    setupBoard();
    _turn = Turn(players: players, currentPlayer: players.first);

    notifyListeners();
  }

  Future<void> setupBoard() async {}

  bool get canDrawCard {
    return turn.drawCount < 1;
  }

  Future<void> drawCardToDiscardPile({int count = 1}) async {
    final draw = await _service.drawCards(_currentDeck!, count: count);

    _currentDeck!.remaining = draw.remaining;
    _discards.addAll(draw.cards);

    notifyListeners();
  }

  void setBottomWidget(Widget? widget) {
    bottomWidget = widget;
    notifyListeners();
  }

  void setTrump(Suit suit) {
    setBottomWidget(Card(
      child: Text(
        CardModel.suitToUnicode(suit),
        style: TextStyle(
          backgroundColor: Colors.white70,
          fontSize: 24,
          color: CardModel.suitToColor(suit),
        ),
      ),
    ));
  }

  void setLastPlayed(CardModel card) {
    gameState[GS_LAST_SUIT] = discardTop!.suit;
    gameState[GS_LAST_VALUE] = discardTop!.value;

    setTrump(card.suit);

    notifyListeners();
  }

  bool canPlayCard(CardModel card) {
    if (gameIsOver) return false;
    return _turn.actionCount < 1;
  }

  Future<void> drawCards(
    PlayerModel player, {
    int count = 1,
    bool allowAnyTime = false,
  }) async {
    if (currentDeck == null) return;
    if (!allowAnyTime && !canDrawCard) return;

    final draw = await _service.drawCards(_currentDeck!, count: count);

    player.addCards(draw.cards);

    _turn.drawCount += count;

    _currentDeck!.remaining = draw.remaining;

    notifyListeners();
  }

  Future<void> playCard({
    required PlayerModel player,
    required CardModel card,
  }) async {}

  Future<void> applyCardSideEffects(CardModel card) async {}

  bool get canEndTurn {
    return turn.drawCount > 0;
  }

  void endTurn() {
    _turn.nextTurn();
    if (_turn.currentPlayer.isBot) {
      botTurn();
      notifyListeners();
    }
  }

  void skipTurn() {
    _turn.nextTurn();
    _turn.nextTurn();
    notifyListeners();
  }

  bool get gameIsOver {
    return currentDeck!.remaining < 1;
  }

  void finishGame() {
    showToast("Game Over!");
    notifyListeners();
  }

  Future<void> botTurn() async {}

  void showToast(String message, {int seconds = 3, SnackBarAction? action}) {
    rootScaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: seconds),
      action: action,
    ));
  }
}

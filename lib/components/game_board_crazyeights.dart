import 'package:cardgames/components/card_list.dart';
import 'package:cardgames/components/discard_pile.dart';
import 'package:cardgames/components/player_info.dart';
import 'package:cardgames/components/playing_card.dart';
import 'package:cardgames/providers/crazy_eights_game_provider.dart';
import 'package:cardgames/providers/game_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/card_model.dart';
import '../models/player_model.dart';
import 'deck_pile.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CrazyEightsGameProvider>(builder: (context, model, child) {
        return model.currentDeck != null
            ? Column(
              children: [
                PlayerInfo(turn: model.turn),
                Expanded(
                  child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await model.drawCards(model.turn.currentPlayer);
                                    },
                                    child: DeckPile(
                                      remaining: model.currentDeck!.remaining,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  DiscardPile(cards: model.discards),
                                ],
                              ),
                              if(model.bottomWidget != null) model.bottomWidget!
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: CardList(
                            player: model.players[1],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (model.turn.currentPlayer == model.players[0])
                                      ElevatedButton(
                                        onPressed: model.canEndTurn
                                            ? () {
                                                model.endTurn();
                                              }
                                            : null,
                                        child: const Text("End Turn"),
                                      )
                                  ],
                                ),
                              ),
                              CardList(
                                player: model.players[0],
                                onPlayCard: (CardModel card){
                                  model.playCard(player: model.players[0], card: card);
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                ),
              ],
            )
            : Center(
                child: TextButton(
                    onPressed: () {
                      final players = [
                        PlayerModel(name: "Player One", isHuman: true),
                        PlayerModel(name: "CPU", isHuman: false)
                      ];
                      model.newGame(players);
                    },
                    child: const Text("New Game")));
      });
  }
}

import 'package:cardgames/components/card_list.dart';
import 'package:cardgames/components/gofishbooks/gofish_books.dart';
import 'package:cardgames/components/player_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/card_model.dart';
import '../models/player_model.dart';
import '../providers/go_fish_game_provider.dart';
import 'deck_pile.dart';

class GameBoard2 extends StatelessWidget {
  const GameBoard2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<GoFishGameProvider>(builder: (context, model, child) {
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
                                Container(
                                  color: Colors.white,
                                  height: 400,
                                  width: 300,
                                  child: CustomScrollView(
                                    slivers: [
                                      SliverGrid(
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 50,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                        ),
                                        delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                          return model.foundCase == true?
                                          GoFishBooks(cards: model.allBooks) :
                                              const Placeholder();
                                        },
                                            childCount:
                                                model.toRemove.length),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 75,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await model
                                        .drawCards(model.turn.currentPlayer);
                                  },
                                  child: DeckPile(
                                    remaining: model.currentDeck!.remaining,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
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
                                  if (model.turn.currentPlayer ==
                                      model.players[0])
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
                              onPlayCard: (CardModel card) {
                                model.playCard(
                                    player: model.players[0], card: card);
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

import 'package:cardgames/models/player_model.dart';
import 'package:cardgames/providers/crazy_eights_game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/game_board_crazyeights.dart';
import 'game_choice_screen.dart';


class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final CrazyEightsGameProvider _gameProvider;
  @override
  void initState() {
    _gameProvider = Provider.of<CrazyEightsGameProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Crazy Eights'),
          actions: [
            TextButton(
              onPressed: () async {
                final players = [
                  PlayerModel(name: "Player One", isHuman: true),
                  PlayerModel(name: "CPU", isHuman: false)
                ];
                await _gameProvider.newGame(players);
              },
              child: const Text('New Game'),
            )
          ],
        ),
        /*GameBoard() use to go here, ideally, you'll want to make a screen of
        card game options.
        * */
        body: const GameBoard());
  }
}

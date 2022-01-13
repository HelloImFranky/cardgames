import 'package:cardgames/providers/crazy_eights_game_provider.dart';
import 'package:cardgames/providers/go_fish_game_provider.dart';
import 'package:cardgames/screens/game_choice_screen.dart';
import 'package:cardgames/screens/game_screen_crazyeights.dart';
import 'package:cardgames/screens/game_screen_gofish.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CrazyEightsGameProvider()),
      ChangeNotifierProvider(create: (_) => GoFishGameProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      routes: {
        '/gameBoard': (context) => const GameScreen(),
        '/gameBoard2': (context) => const GameScreen2(),
      },
      theme: ThemeData.dark(),
      home: const GameChoice(),
    );
  }
}

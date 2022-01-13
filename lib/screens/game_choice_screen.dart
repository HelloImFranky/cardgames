import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class GameChoice extends StatelessWidget {
  const GameChoice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose A Card Game"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 55),
            const Text(
              "Game Choices",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 100),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/gameBoard");
              },
              child: SizedBox(
                width: 100,
                child: Column(
                  children: const [
                    Image(
                      image: AssetImage("images/crazy8sImage.jpeg"),
                    ),
                    Text("Crazy 8's"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, "/gameBoard2");
              },
              child: SizedBox(
                width: 100,
                child: Column(children: const [
                  Image(
                    image: AssetImage("images/gofish.png"),
                  ),
                  Text("Go Fish"),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

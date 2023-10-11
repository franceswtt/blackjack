import 'dart:async';

import 'package:blackjack/widgets/popup_builder.dart';
import 'package:flutter/material.dart';
import 'package:spring/spring.dart';

import 'colors/app_colors.dart';
import 'data/deck.dart';
import 'data/playing_card.dart';
import 'logic/game_logic.dart';

class BlackjackApp extends StatefulWidget {
  const BlackjackApp({super.key});

  @override
  State<BlackjackApp> createState() => _BlackjackAppState();
}

class _BlackjackAppState extends State<BlackjackApp> {
  final Deck deck = Deck();
  List<PlayingCard> _dealerHand = [];
  List<PlayingCard> _playerHand = [];
  int _playerScore = 0;
  int _dealerScore = 0;
  bool _isPlaying = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _startNewGame() {
    List<PlayingCard> playerHand = Deck().generateHand(2);
    List<PlayingCard> dealerHand = Deck().generateHand(2);

    int playerScore = calculateHandScore(playerHand);
    int dealerScore = calculateHandScore(dealerHand);

    setState(() {
      _playerHand.clear();
      _dealerHand.clear();
      _playerHand = playerHand;
      _dealerHand = dealerHand;
      _playerScore = playerScore;
      _dealerScore = dealerScore;
      _isPlaying = true;
    });

    if (_playerScore == 21) {
      Timer(
        const Duration(seconds: 2),
        () => showResultPopup(Result.win),
      );
      _endGame();
    }
  }

  void _hit() {
    List<PlayingCard> playerHand = List.from(_playerHand)..add(deck.drawCard());

    int playerScore = calculateHandScore(playerHand);

    setState(() {
      _playerHand = playerHand;
      _playerScore = playerScore;
    });
    if (_playerScore > 21) {
      showResultPopup(Result.lose);

      _endGame();
    }
  }

  void _stand() {
    List<PlayingCard> dealerHand = [..._dealerHand];
    int dealerScore = _dealerScore;

    while (dealerScore < 17) {
      dealerHand.add(deck.drawCard());
      dealerScore = calculateHandScore(dealerHand);
    }

    // Determine the winner here
    showResultPopup(
      dealerScore > _playerScore && dealerScore <= 21
          ? Result.lose
          : dealerScore == _playerScore
              ? Result.draw
              : Result.win,
    );

    _endGame();
  }

  void _endGame() {
    setState(() {
      _isPlaying = false;
    });
  }

  void showResultPopup(Result result) {
    if (context.mounted) {
      ResultPopup.showResultPopup(
        context: context,
        result: result,
        dealerHand: _dealerHand,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.secondaryColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/blackjack.png'),
              Spring.bubbleButton(
                onTap: _startNewGame,
                child: Container(
                  width: 150.0,
                  padding: const EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: AppColors.primaryColor,
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Start New Game',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 150.0,
              ),
              if (_playerHand.isNotEmpty) ...[
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < _playerHand.length; i++) ...[
                      if (_playerHand.length == 2 ||
                          i == _playerHand.length - 1) ...[
                        Spring.slide(
                          slideType: SlideType.slide_in_left,
                          child: PlayingCard.getCardImage(_playerHand[i]),
                        )
                      ] else ...[
                        PlayingCard.getCardImage(_playerHand[i]),
                      ],
                    ],
                  ],
                ),
                const Text(
                  'Your Cards',
                  style: TextStyle(
                    height: 2,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
              ] else ...[
                const SizedBox(
                  height: 100.0,
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryButtonColor,
                    ),
                    onPressed: _isPlaying ? _hit : null,
                    child: const Text(
                      'Hit',
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryButtonColor,
                    ),
                    onPressed: _isPlaying ? _stand : null,
                    child: const Text('Stand'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spring/spring.dart';

import '../colors/app_colors.dart';
import '../data/playing_card.dart';

enum Result {
  win,
  lose,
  draw,
}

extension ResultExtension on Result {
  String get text {
    switch (this) {
      case Result.win:
        return 'You Win';
      case Result.lose:
        return 'You Lose';
      case Result.draw:
        return 'Draw';
    }
  }

  String get image {
    switch (this) {
      case Result.win:
        return 'assets/images/win.png';
      case Result.lose:
        return 'assets/images/lose.png';
      case Result.draw:
        return 'assets/images/draw.png';
    }
  }

  String get animation {
    switch (this) {
      case Result.win:
        return 'assets/animations/win.json';
      case Result.lose:
        return 'assets/animations/lose.json';
      case Result.draw:
        return 'assets/animations/draw.json';
    }
  }
}

class ResultPopup {
  static void _showDialog({
    required BuildContext context,
    required Widget Function(BuildContext context) builder,
  }) {
    showDialog(
      useRootNavigator: false,
      barrierDismissible: false,
      context: context,
      builder: builder,
    );
  }

  static showResultPopup({
    required BuildContext context,
    required Result result,
    required List<PlayingCard> dealerHand,
  }) {
    _showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              result.image,
              width: 100,
            ),
            Lottie.asset(
              result.animation,
              width: 200,
              fit: BoxFit.contain,
            ),
            const Text(
              "Dealer's Cards",
              style: TextStyle(
                height: 2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final card in dealerHand)
                  Flexible(
                    child: Spring.slide(
                      slideType: SlideType.slide_in_top,
                      child: PlayingCard.getCardImage(card),
                    ),
                  ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

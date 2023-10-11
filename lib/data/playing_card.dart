import 'package:flutter/widgets.dart';

class PlayingCard {
  PlayingCard(this.suit, this.rank);

  final String rank;
  final String suit;

  static Image getCardImage(PlayingCard card) {
    String suit = card.suit.toLowerCase();
    String rank = card.rank.toLowerCase();
    return Image.asset(
      'assets/images/cards/English_pattern_$rank'
      '_of_$suit.png',
      width: 100,
    );
  }
}

import 'dart:math';

import 'playing_card.dart';

class Deck {
  final List<PlayingCard> _cards = [];
  final List<String> _ranks = [
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    'Jack',
    'Queen',
    'King',
    'Ace'
  ];

  final List<String> _suits = [
    'Hearts',
    'Diamonds',
    'Clubs',
    'Spades',
  ];

  Deck() {
    for (var suit in _suits) {
      for (var rank in _ranks) {
        _cards.add(PlayingCard(suit, rank));
      }
    }
    _shuffle();
  }

  PlayingCard drawCard() {
    if (_cards.isEmpty) {
      _shuffle();
    }
    return _cards.removeAt(0);
  }

  void _shuffle() {
    _cards.shuffle(Random());
  }

  List<PlayingCard> generateHand(int count) {
    return List.generate(count, (_) => drawCard());
  }
}

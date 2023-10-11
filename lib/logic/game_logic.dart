import '../data/playing_card.dart';

int calculateHandScore(List<PlayingCard> hand) {
  int score = 0;
  int aceCount = 0;

  for (var card in hand) {
    if (card.rank == 'Ace') {
      aceCount++;
    } else if (card.rank == 'Jack' ||
        card.rank == 'Queen' ||
        card.rank == 'King') {
      score += 10;
    } else {
      score += int.parse(card.rank);
    }
  }

  for (var i = 0; i < aceCount; i++) {
    if (score + 11 <= 21) {
      score += 11;
    } else {
      score += 1;
    }
  }

  return score;
}

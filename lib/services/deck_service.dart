import 'package:cardgames/models/deck_model.dart';
import 'package:cardgames/models/draw_model.dart';

import '../network/deckapiprovider.dart';

class DeckService extends DeckAPIProvider {
  Future<DeckModel> newDeck([int deckCount = 1]) async {
    final data =
        await httpGet('/deck/new/shuffle', params: {'deck_count': deckCount});

    return DeckModel.fromJson(data);
  }

  Future<DrawModel> drawCards(DeckModel deck, {int count = 1}) async {
    final data = await httpGet(
      '/deck/${deck.deckId}/draw',
      params: {'count': count},
    );
    return DrawModel.fromJson(data);
  }
}

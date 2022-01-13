class DeckModel {
  bool shuffled = false;
  final String deckId;
  int remaining = 0;


  DeckModel({required this.deckId, required this.shuffled, required this.remaining});


  factory DeckModel.fromJson(Map<String, dynamic> json){
    return DeckModel(deckId: json['deck_id'], shuffled: json['shuffled'], remaining: json['remaining']);
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deck_id'] = deckId;
    data['remaining'] = remaining;
    return data;
  }


}
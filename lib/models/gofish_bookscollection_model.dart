import 'package:cardgames/components/gofishbooks/gofish_books.dart';

import 'card_model.dart';

class GoFishBooksCollectionModel {
   List<CardModel> fishBooks = [];
   double? size;

   GoFishBooksCollectionModel();

   GoFishBooksCollectionModel.defaultConst(this.fishBooks, this.size);


}

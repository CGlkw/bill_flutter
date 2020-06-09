import 'package:flutter/cupertino.dart';
import 'package:bill/view/yyets/app/Stroage.dart';

class FavSortType extends ChangeNotifier {
  int sortType = 0;

  FavSortType() {
    favoritesSortType.then((value) {
      setType(value);
    });
  }

  setType(int type) {
    sortType = type;
    notifyListeners();
  }
}

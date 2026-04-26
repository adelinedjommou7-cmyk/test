import 'package:flutter/foundation.dart';

class DownloadProvider extends ChangeNotifier {
  bool isDownloadTapped = false;
  String? gameTitle;
  String? image;
  String? niveau;
  String? niveauStat;
  String? index;

  void setHovering(bool value) {
    isDownloadTapped = value;

    notifyListeners();
  }

  void setDownloading(String label, String image) {
    gameTitle = label;
    this.image = image;

    notifyListeners();
  }

  void setMenu(String label) {
    niveau = label;
    notifyListeners();
  }

  void setMenuStat(String label) {
    niveauStat = label;
    notifyListeners();
  }

  void setIndex(String label) {
    index = label;
    notifyListeners();
  }
}

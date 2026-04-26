//check if it's a web link
bool isURL(String text) {
  final urlRegex = RegExp(
      r"((http|https)://)(www\.)?([a-zA-Z0-9@:%._\+~#?&//=]*)\.([a-zA-Z0-9.-]+)(/[a-zA-Z0-9.-_\+~#?&//=]*)?");
  return urlRegex.hasMatch(text);
}

//check if it's a pdf router
bool isPDFPath(String text) {
  final pdfRegex = RegExp(r".*\.pdf$");
  return pdfRegex.hasMatch(text);
}

String clickUrl = "sfx/click1.mp3";
String soundSplashUrl = "sfx/click1.mp3";

String removeDiacriticss(String str) {
  const withAccents =
      'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ';
  const withoutAccents =
      'AAAAAAAECEEEEIIIIDNOOOOOOUUUUYTHssaaaaaaaeceeeeiiiionoooooouuuuythy';

  String result = '';
  for (int i = 0; i < str.length; i++) {
    int index = withAccents.indexOf(str[i]);
    if (index != -1) {
      result += withoutAccents[index];
    } else {
      result += str[i];
    }
  }
  return result;
}

Map<String, String> accents = {
  'â': 'a', 'à': 'a', 'ä': 'a',
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
  // Ajoutez d'autres paires d'accents ici si nécessaire
};
String removeDiacritics(String str) {
  // Convertit la chaîne en minuscules pour une comparaison insensible à la casse
  str = str.toLowerCase();

  // Crée une nouvelle chaîne en remplaçant les accents
  String normalizedString =
      str.replaceAllMapped(RegExp(accents.keys.join('|')), (match) {
    return accents[match.group(0)]!;
  });

  return normalizedString;
}

String convertRessourceTitle({int? index}) {
  switch (index) {
    case 1:
      return 'Fiches d\'activité';
    case 2:
      return 'Banque de projets STIM';
    case 3:
      return 'Histoires personnalisées';
    case 4:
      return 'Matériel de classe';
    case 5:
      return 'Activités en ligne';
    default:
      return 'Jeux en ligne';
  }
}

String convertLevelTitle(String? niveau, {String? index}) {
  switch (niveau) {
    case '1':
      return ' Niveau 1ere';
    case '2':
      return ' Niveau 2e';
    case '3':
      return ' Niveau 3e';
    case '4':
      return ' Niveau 4e';
    case '5':
      return ' Niveau 5e';
    case '6':
      return ' Niveau 6e';
    default:
      return ' Préscolaire';
  }
}

String convertLevelsTitle(String? niveau) {
  switch (niveau) {
    case '1':
      return ' 1e niveau';
    case '2':
      return ' 2e niveau';
    case '3':
      return ' 3e niveau';
    case '4':
      return ' 4e niveau';
    case '5':
      return ' 5e niveau';
    case '6':
      return ' 6e niveau';
    default:
      return ' Préscolaire';
  }
}

String convertLevel(String? niveau) {
  switch (niveau) {
    case '1':
      return '1ere';
    case '2':
      return '2e';
    case '3':
      return '3e';
    case '4':
      return '4e';
    case '5':
      return '5e';
    case '6':
      return '6e';
    default:
      return 'Prescolaire';
  }
}

String convertModeTitle(String mode) {
  switch (mode) {
    case 'system':
      return ' Automatique';
    case 'light':
      return ' Lumineux';
    case 'dark':
      return ' Sombre';
    default:
      return '';
  }
}

String convertNavigatorTitle(String nav) {
  switch (nav) {
    case 'auto':
      return ' Automatique';
    case 'top':
      return ' Au sommet';
    case 'open':
      return ' Ouvert';
    case 'minimal':
      return ' Minime';
    case 'left':
      return ' À gauche';
    default:
      return 'Compact';
  }
}

int convertRessourceIndex({String? index}) {
  switch (index) {
    case '/':
      return 0;
    case '/category/activite_en_ligne':
      return 1;
    case '/category/b_projet_stim':
      return 2;
    case '/category/fiche_activite':
      return 3;
    case '/category/jeu_en_ligne':
      return 4;
    case '/category/historiq_perso':
      return 5;
    case '/category/material_class':
      return 6;
    case '/settings':
      return 7;
    default:
      return 8;
  }
}

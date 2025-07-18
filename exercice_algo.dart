import 'dart:core';

void main() {
  const chaineArticles = "163841689525773";

  print("Chaîne d'articles en entrée : $chaineArticles\n");

  final resultatOptimise = emballageOptimise(chaineArticles);
  final nombreCartonsOptimises = '/'.allMatches(resultatOptimise).length + 1;
  print(
    "Robot optimisé : $resultatOptimise => $nombreCartonsOptimises cartons utilisés",
  );
}

int _somme(List<int> liste) {
  return liste.fold(0, (previousValue, element) => previousValue + element);
}

/// Algorithme "First Fit Decreasing".
String emballageOptimise(String articles) {
  if (articles.isEmpty) return "";

  // Convertit la chaîne en une liste d'entiers
  List<int> items = articles.split('').map(int.parse).toList();

  // Trier les articles par taille, du plus grand au plus petit.
  items.sort((a, b) => b.compareTo(a));

  final List<List<int>> cartons = [];
  const capaciteCarton = 10;

  for (final article in items) {
    bool articlePlace = false;

    // Chercher le 1er carton existant où l'article peut rentrer
    for (final carton in cartons) {
      if (_somme(carton) + article <= capaciteCarton) {
        carton.add(article);
        articlePlace = true;
        break; // On a trouvé une place, on passe à l'article suivant
      }
    }

    //Si aucun carton existant ne convient, en créer un nouveau
    if (!articlePlace) {
      cartons.add([article]);
    }
  }

  // Formater la chaîne de sortie
  return cartons.map((carton) => carton.join('')).join('/');
}

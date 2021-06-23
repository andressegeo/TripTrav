import 'package:flutter/material.dart';
import 'views/home/home_view.dart';
import 'views/city/city_view.dart';
import 'widgets/data.dart';

main() {
  runApp(DymaTrip());
}

class DymaTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.green,
        appBarTheme: AppBarTheme(
          // definition d'un theme pour le texte dans nos AppBar
          // en copiant les memes valeurs d'autres features mais en modifiant juste le fontSize du texte
          textTheme: ThemeData.light().textTheme.copyWith(
                // use headline6 instead title who's deprecated
                headline6: TextStyle(fontSize: 30),
              ),
        ),
        // definition d'un textTheme generique(pas qu'à l'AppBAr)
        // Pour l'utiliser dans un composant, exploiter l'inheritedWidget qu'est theme
        // dans le widget enfant puis appeler la propriété headline6
        // Le texte de l'enfant aura donc la couleur Bleu
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                color: Colors.blue,
                // fontSize: 30,
              ),
            ),
      ),
      debugShowCheckedModeBanner: false,
      // home: HomeView(),
      home: Data(
        child: CityView(),
      ),
    );
  }
}

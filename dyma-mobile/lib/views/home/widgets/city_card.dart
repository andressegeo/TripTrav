import 'package:flutter/material.dart';
import '../../../models/city_model.dart';

class CityCard extends StatelessWidget {
  final City city;

  CityCard({this.city});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Ink.image(
              // Le ink ici permet d'appeler le InkWell qui lui va aider à
              // faire ressortir la sensation(la vaguelette) de Tap sur l'image
              // image: AssetImage(city.image),
              image: NetworkImage(city.image),
              fit: BoxFit.cover,
              child: InkWell(
                onTap: () {
                  // pushNamed va pousser via la route à trigger le widget à stacker en haut de la pile
                  // via pushNamed on peut envoyer des arguments à la view pushé en exploitant la propriété argument
                  // la recuperation de l'enfant se fera via la classe ModalRoute
                  // ModalRoute.of(context).settings.arguments;
                  Navigator.pushNamed(
                    context,
                    "/city", // If we passed and unknowRoute(/qsdqlsdj for e.g), it will call not_found view on 404 folder
                    arguments: city.name,
                  );
                },
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: Colors.black54,
                child: Text(
                  city.name,
                  style: const TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

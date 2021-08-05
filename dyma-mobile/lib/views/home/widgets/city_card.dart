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
            // Permet de detecter des events que fait un user sur son tel
            // Zoomer avec ses 2 doigts, doubleTap, Tap, Press, le Gesture permet de le savoir
            GestureDetector(
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
              child: Hero(
                tag: city.name,
                child: Image.network(
                  city.image,
                  fit: BoxFit.cover,
                ),
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

import 'package:flutter/material.dart';
import '../../../views/city/city_view.dart';
import '../../../widgets/data.dart';
import '../../../models/city_model.dart';

class CityCard extends StatelessWidget {
  // final String name;
  // final String image;
  // final bool checked;
  // final Function updateChecked;
  final City city;

  CityCard({this.city});
  // CityCard({this.name, this.image, this.checked, this.updateChecked});

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
              image: AssetImage(city.image),
              fit: BoxFit.cover,
              child: InkWell(
                onTap: () {
                  // Quand on tape sur la ville, Navigator permet de stacker en haut de la pile via Push
                  // La view City, Ici Le MaterialPageRoute permet en plus de passer la Ville, d'ajouter l'animation
                  // permettant de rendre fluide la transition pour l'affichage de la cityView
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Data(child: CityView());
                      },
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: Colors.black54,
                child: Text(
                  city.name,
                  style: TextStyle(
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

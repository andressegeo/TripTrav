import 'package:flutter/material.dart';
import '../../../models/activity_model.dart';

class ActivityCard extends StatelessWidget {
  final Activity? activity;
  final bool? isSelected;
  final Function? toggleActivity;

  ActivityCard({
    this.activity,
    this.isSelected,
    this.toggleActivity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        // on veut le plus grand espace disponible utiliser double.infinity
        // width: double.infinity,
        // height: 250,
        margin: const EdgeInsets.all(5),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Ink.image(
              image: NetworkImage(activity!.image!),
              fit: BoxFit.cover,
              child: InkWell(
                onTap: toggleActivity as void Function()?,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isSelected!)
                          const Icon(
                            Icons.check,
                            size: 40,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        // adapte la taille du texte pour cela s'adapte sur une ou +sieurs ligne
                        child: FittedBox(
                          // Sur une ligne, remove to see in 2 ligne
                          child: Text(
                            activity!.name,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ));

    // return ListTile(
    //   // leading: Image.asset(
    //   //   activity.image,
    //   //   width: 100,
    //   // ),
    //   leading: CircleAvatar(backgroundImage: AssetImage(activity.image)),
    //   title: Text(activity.name),
    //   subtitle: Text(activity.city),
    //   contentPadding: EdgeInsets.all(10),
    //   trailing: Checkbox(
    //     value: true,
    //     tristate: true,
    //     onChanged: (e) => {},
    //     activeColor: Colors.black,
    //     checkColor: Colors.red,
    //   ),
    // );
  }
}

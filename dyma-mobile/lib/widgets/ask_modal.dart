import 'package:flutter/material.dart';

Future<String?> askModal(BuildContext context, String question) {
  return Navigator.push(
    // On push un widget sur le top de notre Stack
    context,
    // PageRouteBuilder permet de pousser le context en modal
    PageRouteBuilder(
      opaque:
          false, // Permet de rendre visible le widget parent. l'enfant ne sera pas opaque
      pageBuilder: (context, _, __) {
        return AskModal(
          question: question,
        );
      },
    ),
  );
}

class AskModal extends StatelessWidget {
  final String? question;
  AskModal({this.question});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      alignment: Alignment.center,
      child: Card(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(question!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      child: Text("Ok"),
                      onPressed: () {
                        // pop de Navigator permet de retourner l'info au parent
                        Navigator.pop(context, "Ok");
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      )),
                  ElevatedButton(
                    child: Text("Annuler"),
                    onPressed: () {
                      Navigator.pop(context, "Annuler");
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

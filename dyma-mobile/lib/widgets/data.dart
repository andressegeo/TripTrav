import 'package:flutter/material.dart';
import 'package:project_dyma_end/models/city_model.dart';

class Data extends InheritedWidget {
  // Cette class InheritedWidget comme ces soeurs Stateless et StateFull
  // a la différence permet de forwarder la data entre tous ces wwidgets enfants
  // cela facilite la propagation de données entre les enfants et evite d'utiliser
  // et de toujours passer systematiquement une function du parent aux enfant qui persiste la données
  final List<City> activities = [];

  Data({required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // Quand un enfant va recevoir la data et qu'elle est modifié, le
    // updateShouldNotify permet de savoir ou pas si on veut rebuild le widget enfant
    return true;
  }

  static of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Data>();
  }
}

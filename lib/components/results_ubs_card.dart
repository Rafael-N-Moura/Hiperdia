import 'package:flutter/material.dart';
import 'package:hiperdia/models/Ubs.dart';

class ResultsUbsCard extends StatelessWidget {
  ResultsUbsCard({Key key, @required this.ubs}) : super(key: key);
  Ubs ubs = Ubs();
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
              child: Text(
                "Data: ${ubs.date}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
              child: Text(
                "Local: ${ubs.place}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
              child: Text(
                "Profissional: ${ubs.professional}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 18, top: 18),
              child: Text(
                "Nome do Profissional: ${ubs.professionalName}",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

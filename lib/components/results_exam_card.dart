import 'package:flutter/material.dart';

class ResultsExamCard extends StatelessWidget {
  ResultsExamCard({Key key, @required this.date, @required this.results})
      : super(key: key);
  String date;
  String results;
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
              padding: const EdgeInsets.only(left: 16, top: 18),
              child: Text(
                "Data: $date",
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
            //   child: Divider(color: Colors.black, thickness: 1),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Text(
                "Resultados: $results",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

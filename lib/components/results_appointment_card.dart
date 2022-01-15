import 'package:flutter/material.dart';
import 'package:hiperdia/models/Appointment.dart';

class ResultsAppointmentCard extends StatelessWidget {
  ResultsAppointmentCard({Key key, @required this.appointment})
      : super(key: key);
  Appointment appointment = Appointment();
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
                "Data: ${appointment.date}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Text(
                "Local: ${appointment.place}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 18),
              child: Text(
                "Nome do Médico: ${appointment.doctorName}",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

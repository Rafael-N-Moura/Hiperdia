import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hiperdia/models/Patient.dart';
import 'package:hiperdia/screens/patient_screen.dart';

String type;
Color colorType;
Color colorRisk;

class PatientCard extends StatefulWidget {
  PatientCard({Key key, @required this.curPatient}) : super(key: key);

  Patient curPatient = Patient();

  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  @override
  void didUpdateWidget(covariant PatientCard oldWidget) {
    // TODO: implement didUpdateWidget
    if (widget.curPatient.disease == 'Diabetes') {
      setState(() {
        type = 'D';
        colorType = Colors.blue;
      });
    }
    if (widget.curPatient.disease == 'Hipertensão') {
      setState(() {
        type = 'H';
        colorType = Colors.red;
      });
    }
    if (widget.curPatient.disease == 'Diabetes e Hipertensão') {
      setState(() {
        type = 'DH';
        colorType = Colors.grey;
      });
    }
    if (widget.curPatient.risk == 'Baixo') {
      setState(() {
        colorRisk = Colors.blue;
      });
    }
    if (widget.curPatient.risk == 'Médio') {
      setState(() {
        colorRisk = Colors.yellow;
      });
    }
    if (widget.curPatient.risk == 'Alto') {
      setState(() {
        colorRisk = Colors.orange;
      });
    }
    if (widget.curPatient.risk == 'Muito Alto') {
      setState(() {
        colorRisk = Colors.red;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.curPatient.disease == 'Diabetes') {
      setState(() {
        type = 'D';
        colorType = Colors.blue;
      });
    }
    if (widget.curPatient.disease == 'Hipertensão') {
      setState(() {
        type = 'H';
        colorType = Colors.red;
      });
    }
    if (widget.curPatient.disease == 'Diabetes e Hipertensão') {
      setState(() {
        type = 'DH';
        colorType = Colors.grey;
      });
    }
    if (widget.curPatient.risk == 'Baixo') {
      setState(() {
        colorRisk = Colors.blue;
      });
    }
    if (widget.curPatient.risk == 'Médio') {
      setState(() {
        colorRisk = Colors.yellow;
      });
    }
    if (widget.curPatient.risk == 'Alto') {
      setState(() {
        colorRisk = Colors.orange;
      });
    }
    if (widget.curPatient.risk == 'Muito Alto') {
      setState(() {
        colorRisk = Colors.red;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 350),
            pageBuilder: (context, _, __) => PatientScreen(
              curPatient: widget.curPatient,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Hero(
                tag: widget.curPatient.cpf,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: widget.curPatient.image == 'bolo'
                      ? Image.asset(
                          'assets/images/genericAvatar.png',
                        )
                      : Image.file(
                          File(widget.curPatient.image),
                        ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.curPatient.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                'Tipo',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              type,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: colorType,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                'Risco',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              widget.curPatient.risk,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: colorRisk,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

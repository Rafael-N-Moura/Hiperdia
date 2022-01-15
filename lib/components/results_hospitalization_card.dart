import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiperdia/models/Hospitalization.dart';
import 'package:hiperdia/models/Patient.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class ResultsHospitalizationCard extends StatefulWidget {
  ResultsHospitalizationCard(
      {Key key, @required this.hospitalization, this.curPatient})
      : super(key: key);

  Hospitalization hospitalization = Hospitalization();
  Patient curPatient = Patient();

  @override
  State<ResultsHospitalizationCard> createState() =>
      _ResultsHospitalizationCardState();
}

class _ResultsHospitalizationCardState
    extends State<ResultsHospitalizationCard> {
  String tempDateEnd;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 18, right: 16),
              child: Text(
                "Data de Ínicio: ${widget.hospitalization.dateStart}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (widget.hospitalization.dateEnd != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 18, right: 16),
                child: Text(
                  "Data da Alta: ${widget.hospitalization.dateEnd}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
            //   child: Divider(color: Colors.black, thickness: 1),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 18, right: 16),
              child: Text(
                "Local: ${widget.hospitalization.place}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, bottom: 16, top: 18, right: 16),
              child: Text(
                "Causa: ${widget.hospitalization.cause}",
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (widget.hospitalization.dateEnd == null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shadowColor: Colors.blueAccent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    minimumSize: const Size(100, 45),
                    //////// HERE
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Registrar Alta"),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        DataInputFormatter(),
                                      ],
                                      validator: (dateEnd) {
                                        if (dateEnd.isEmpty)
                                          return 'Campo obrigatório';
                                        return null;
                                      },
                                      onChanged: (dateEnd) {
                                        setState(() {
                                          tempDateEnd = dateEnd;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: '19/08/1995',
                                        label: const Text('Data da Alta'),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: const BorderSide(
                                            color: Colors.blueGrey,
                                            width: 2.0,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    onPrimary: Colors.white,
                                    shadowColor: Colors.blueAccent,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0)),
                                    minimumSize: const Size(100, 45),
                                    //////// HERE
                                  ),
                                  onPressed: () {
                                    if (tempDateEnd != null) {
                                      widget.hospitalization.dateEnd =
                                          tempDateEnd;
                                      Box<Hospitalization> hospitalizations =
                                          Hive.box<Hospitalization>(
                                              'hospitalizations');
                                      hospitalizations.put(
                                          widget.hospitalization.key,
                                          widget.hospitalization);
                                      widget.curPatient.hospitalization = false;
                                      Hive.box<Patient>('patients').put(
                                          widget.curPatient.cpf,
                                          widget.curPatient);
                                      Navigator.of(context).pop();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Por favor preencha todos os campos',
                                            textAlign: TextAlign.center,
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  child: Text('Registrar'),
                                ),
                                // child: ElevatedButton(
                                //   style: ButtonStyle(
                                //     elevation: MaterialStateProperty.all(7),
                                //     fixedSize: MaterialStateProperty.all<Size>(
                                //       Size(height: 10),
                                //     ),
                                //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                //       RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(18.0),
                                //         //side: BorderSide(color: Colors.white),
                                //       ),
                                //     ),
                                //   ),
                                //   onPressed: () {},
                                //   child: Text("Registar"),
                                // ),
                              ),
                              // FlatButton(
                              //   child: Text("Não"),
                              //   onPressed: () => Navigator.of(context).pop(),
                              // ),
                              // FlatButton(
                              //   child: Text("Sim"),
                              //   onPressed: () async {
                              //     if (formKey3.currentState.validate()) {
                              //       obito.id = widget.curPatient.cpf;
                              //       Box<Obito> obitos = Hive.box<Obito>('obitos');
                              //       obitos.put(widget.curPatient.cpf, obito);
                              //       Box<Patient> patients = Hive.box<Patient>('patients');
                              //       widget.curPatient.death = true;
                              //       await patients.put(
                              //           widget.curPatient.cpf, widget.curPatient);
                              //       Navigator.of(context).pushAndRemoveUntil(
                              //           MaterialPageRoute(
                              //             builder: (context) => Home(),
                              //           ),
                              //           (Route<dynamic> route) => false);
                              //     }
                              //   },
                              // ),
                            ],
                          );
                        });
                  },
                  child: const Text('Registar Alta'),
                ),
                // child: ElevatedButton(
                //   style: ButtonStyle(
                //     elevation: MaterialStateProperty.all(7),
                //     fixedSize: MaterialStateProperty.all<Size>(
                //       Size(height: 10),
                //     ),
                //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //       RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(18.0),
                //         //side: BorderSide(color: Colors.white),
                //       ),
                //     ),
                //   ),
                //   onPressed: () {},
                //   child: Text("Registar"),
                // ),
              ),
          ],
        ),
      ),
    );
  }
}

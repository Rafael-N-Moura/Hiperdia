import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hiperdia/components/results_hospitalization_card.dart';
import 'package:hiperdia/models/Hospitalization.dart';
import 'package:hiperdia/models/Patient.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class HospitalizationScreen extends StatefulWidget {
  HospitalizationScreen({Key key, @required this.curPatient}) : super(key: key);

  Patient curPatient = Patient();

  @override
  State<HospitalizationScreen> createState() => _HospitalizationScreenState();
}

class _HospitalizationScreenState extends State<HospitalizationScreen> {
  Hospitalization hospitalization = Hospitalization();

  FocusNode myfocusNode;
  FocusNode myfocusNode2;

  void initState() {
    myfocusNode = FocusNode();
    myfocusNode2 = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myfocusNode.dispose();
    myfocusNode2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('INTERNAÇÕES'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable:
            Hive.box<Hospitalization>("hospitalizations").listenable(),
        builder: (context, Box<Hospitalization> box, _) {
          if (box.values.isEmpty)
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/hospitalization.svg",
                  height: screen.height * 0.4,
                ),
                // const Text(
                //   "Sem agentes registrados no momento",
                //   style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                // ),
              ],
            );

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              Hospitalization h = box.getAt(index);
              if (h.id == widget.curPatient.cpf) {
                return ResultsHospitalizationCard(
                  hospitalization: h,
                  curPatient: widget.curPatient,
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog(
                  title: Text("Registrar Internação"),
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
                            validator: (dateStart) {
                              if (dateStart.isEmpty) return 'Campo obrigatório';
                              return null;
                            },
                            onChanged: (dateStart) {
                              setState(() {
                                hospitalization.dateStart = dateStart;
                              });
                            },
                            onEditingComplete: () {
                              myfocusNode.requestFocus();
                            },
                            decoration: InputDecoration(
                              hintText: '19/08/1995',
                              label: const Text('Data de Ínicio'),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.blueGrey,
                                  width: 2.0,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: TextFormField(
                            focusNode: myfocusNode,
                            validator: (place) {
                              if (place.isEmpty) return 'Campo obrigatório';
                              return null;
                            },
                            onChanged: (place) {
                              setState(() {
                                hospitalization.place = place;
                              });
                            },
                            onEditingComplete: () {
                              myfocusNode2.requestFocus();
                            },
                            decoration: InputDecoration(
                              hintText: 'Local da Internação',
                              label: const Text('Local'),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.blueGrey,
                                  width: 2.0,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: TextFormField(
                            focusNode: myfocusNode2,
                            validator: (reason) {
                              if (reason.isEmpty) return 'Campo obrigatório';
                              return null;
                            },
                            onChanged: (reason) {
                              setState(() {
                                hospitalization.cause = reason;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Causa da Internação',
                              label: const Text('Causa'),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.blueGrey,
                                  width: 2.0,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
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
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: const Size(100, 45),
                          //////// HERE
                        ),
                        onPressed: () {
                          if (hospitalization.place != null &&
                              hospitalization.dateStart != null &&
                              hospitalization.cause != null) {
                            hospitalization.id = widget.curPatient.cpf;
                            Box<Hospitalization> hospitalizations =
                                Hive.box<Hospitalization>('hospitalizations');
                            hospitalization.key = DateTime.now().toString();
                            hospitalizations.put(
                                hospitalization.key, hospitalization);
                            widget.curPatient.hospitalization = true;
                            Hive.box<Patient>('patients')
                                .put(widget.curPatient.cpf, widget.curPatient);
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
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
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

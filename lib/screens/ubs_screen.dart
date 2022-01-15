import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hiperdia/components/results_exam_card.dart';
import 'package:hiperdia/components/results_ubs_card.dart';
import 'package:hiperdia/models/Exam.dart';
import 'package:hiperdia/models/Ubs.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class UbsScreen extends StatefulWidget {
  UbsScreen({Key key, @required this.patientCpf}) : super(key: key);

  String patientCpf;

  @override
  State<UbsScreen> createState() => _UbsScreenState();
}

class _UbsScreenState extends State<UbsScreen> {
  Ubs ubs = Ubs();

  FocusNode myFocusNode;
  FocusNode myFocusNode2;
  FocusNode myFocusNode3;

  @override
  void initState() {
    myFocusNode = FocusNode();
    myFocusNode2 = FocusNode();
    myFocusNode3 = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myFocusNode.dispose();
    myFocusNode2.dispose();
    myFocusNode3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('UBS'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Ubs>("ubs").listenable(),
        builder: (context, Box<Ubs> box, _) {
          if (box.values.isEmpty)
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/ubs.svg",
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
              Ubs u = box.getAt(index);
              if (u.id == widget.patientCpf) {
                return ResultsUbsCard(
                  ubs: u,
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
                  title: Text("Registrar Consulta"),
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
                            validator: (date) {
                              if (date.isEmpty) return 'Campo obrigatório';
                              return null;
                            },
                            onChanged: (date) {
                              setState(() {
                                ubs.date = date;
                              });
                            },
                            onEditingComplete: () {
                              myFocusNode.requestFocus();
                            },
                            decoration: InputDecoration(
                              hintText: '19/08/2022',
                              label: const Text('Data'),
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
                            focusNode: myFocusNode,
                            validator: (professional) {
                              if (professional.isEmpty)
                                return 'Campo obrigatório';
                              return null;
                            },
                            onChanged: (professional) {
                              setState(() {
                                ubs.professional = professional;
                              });
                            },
                            onEditingComplete: () {
                              myFocusNode2.requestFocus();
                            },
                            decoration: InputDecoration(
                              hintText: 'Profissional',
                              label: const Text('Profissional'),
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
                            focusNode: myFocusNode2,
                            validator: (professionalName) {
                              if (professionalName.isEmpty)
                                return 'Campo obrigatório';
                              return null;
                            },
                            onChanged: (professionalName) {
                              setState(() {
                                ubs.professionalName = professionalName;
                              });
                            },
                            onEditingComplete: () {
                              myFocusNode3.requestFocus();
                            },
                            decoration: InputDecoration(
                              hintText: 'Alfredo Borges',
                              label: const Text('Nome do Profissional'),
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
                            focusNode: myFocusNode3,
                            validator: (place) {
                              if (place.isEmpty) return 'Campo obrigatório';
                              return null;
                            },
                            onChanged: (place) {
                              setState(() {
                                ubs.place = place;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Local',
                              label: const Text('Local da Consulta'),
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
                        onPressed: () async {
                          if (ubs.date != null &&
                              ubs.professional != null &&
                              ubs.professionalName != null &&
                              ubs.place != null) {
                            ubs.id = widget.patientCpf;

                            Box<Ubs> ubsList = Hive.box<Ubs>('ubs');
                            await ubsList.add(ubs);

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

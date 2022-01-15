import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hiperdia/components/results_exam_card.dart';
import 'package:hiperdia/models/Exam.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class ExamScreen extends StatefulWidget {
  ExamScreen({Key key, @required this.examType, @required this.patientCpf})
      : super(key: key);

  String examType;
  String patientCpf;

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  Exam exam = Exam();

  FocusNode myFocusNode;

  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.examType),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Exam>("exams").listenable(),
        builder: (context, Box<Exam> box, _) {
          if (box.values.isEmpty)
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/exam.svg",
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
              Exam e = box.getAt(index);
              if (e.type == widget.examType && e.id == widget.patientCpf) {
                return ResultsExamCard(
                  date: e.date,
                  results: e.results,
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
                  title: Text("Registrar ${widget.examType}"),
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
                                exam.date = date;
                              });
                            },
                            onEditingComplete: () {
                              myFocusNode.requestFocus();
                            },
                            decoration: InputDecoration(
                              hintText: '19/08/1995',
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
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            validator: (results) {
                              if (results.isEmpty) return 'Campo obrigatório';
                              return null;
                            },
                            onChanged: (results) {
                              setState(() {
                                exam.results = results;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Resultados',
                              label: const Text('Resultados'),
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
                          if (exam.results != null && exam.date != null) {
                            exam.id = widget.patientCpf;
                            exam.type = widget.examType;
                            Box<Exam> exams = Hive.box<Exam>('exams');
                            await exams.add(exam);

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

import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiperdia/components/exam_card.dart';
import 'package:hiperdia/models/Obito.dart';
import 'package:hiperdia/models/Patient.dart';
import 'package:hiperdia/screens/appointment_screen.dart';
import 'package:hiperdia/screens/edit_patient.dart';
import 'package:hiperdia/screens/exam_screen.dart';
import 'package:hiperdia/screens/home.dart';
import 'package:hiperdia/screens/hospitalization_screen.dart';
import 'package:hiperdia/screens/ubs_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

List<String> hipertenso = [
  'ECG',
  'LDL',
  'HDL',
  'TRIGLICERIDES',
  'CREATININA',
  'MICROALBUMINURIA'
];
List<String> diabetico = [
  'GLICEMIA',
  'HEMOGLOBINA GLICADA',
  'MICROALBUMINURIA',
  'CREATININA',
  'LDL',
  'HDL',
  'TRIGLICERIDES'
];
List<String> hipertensoDiabetico = [
  'ECG',
  'HDL',
  'LDL',
  'TRIGLICERIDES',
  'CREATININA',
  'MICROALBUMINURIA',
  'GLICEMIA',
  'HEMOGLOBINA GLICADA'
];

List<String> exams = ['bolo'];

class PatientScreen extends StatefulWidget {
  PatientScreen({Key key, @required this.curPatient}) : super(key: key);

  Patient curPatient = Patient();

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  FocusNode myfocusNode;
  FocusNode myfocusNode2;

  @override
  void didUpdateWidget(covariant PatientScreen oldWidget) {
    // TODO: implement didUpdateWidget
    // exams.clear();
    if (widget.curPatient.disease == 'Diabetes')
      setState(() {
        exams = diabetico;
      });
    if (widget.curPatient.disease == 'Hipertensão')
      setState(() {
        exams = hipertenso;
      });
    if (widget.curPatient.disease == 'Diabetes e Hipertensão')
      setState(() {
        exams = hipertensoDiabetico;
      });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myfocusNode.dispose();
    myfocusNode2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    myfocusNode = FocusNode();
    myfocusNode2 = FocusNode();
    // exams.clear();

    if (widget.curPatient.disease == 'Diabetes')
      setState(() {
        exams = diabetico;
      });
    if (widget.curPatient.disease == 'Hipertensão')
      setState(() {
        exams = hipertenso;
      });
    if (widget.curPatient.disease == 'Diabetes e Hipertensão')
      setState(() {
        exams = hipertensoDiabetico;
      });

    super.initState();
  }

  Obito obito = Obito();
  final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(Icons.arrow_back, color: Colors.blue),
              ),
            ),
          ),
          actions: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 10),
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 350),
                            pageBuilder: (context, _, __) => EditPatientScreen(
                              curPatient: widget.curPatient,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (!widget.curPatient.death)
                  Form(
                    key: formKey3,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          icon: const Icon(Icons.dangerous),
                          color: Colors.red,
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Registrar Óbito"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              DataInputFormatter(),
                                            ],
                                            validator: (date) {
                                              if (date.isEmpty)
                                                return 'Campo obrigatório';
                                              return null;
                                            },
                                            onChanged: (date) {
                                              setState(() {
                                                obito.date = date;
                                              });
                                            },
                                            onEditingComplete: () {
                                              myfocusNode.requestFocus();
                                            },
                                            decoration: InputDecoration(
                                              hintText: '19/08/1995',
                                              label: const Text('Data'),
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
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 2.0,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 2.0,
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 10),
                                          child: TextFormField(
                                            focusNode: myfocusNode,
                                            validator: (cause) {
                                              if (cause.isEmpty)
                                                return 'Campo obrigatório';
                                              return null;
                                            },
                                            onChanged: (cause) {
                                              setState(() {
                                                obito.cause = cause;
                                              });
                                            },
                                            onEditingComplete: () {
                                              myfocusNode2.requestFocus();
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Causa',
                                              label: const Text('Causa'),
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
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 2.0,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 2.0,
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(
                                        //       horizontal: 25, vertical: 10),
                                        //   child: TextFormField(
                                        //     focusNode: myfocusNode2,
                                        //     validator: (data) {
                                        //       if (data.isEmpty)
                                        //         return 'Campo obrigatório';
                                        //       return null;
                                        //     },
                                        //     onChanged: (data) {
                                        //       setState(() {
                                        //         obito.data = data;
                                        //       });
                                        //     },
                                        //     decoration: InputDecoration(
                                        //       hintText:
                                        //           'Informações sobre o óbito',
                                        //       label: const Text('Dados'),
                                        //       focusedBorder: OutlineInputBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(25.0),
                                        //         borderSide: const BorderSide(
                                        //           color: Colors.blue,
                                        //         ),
                                        //       ),
                                        //       enabledBorder: OutlineInputBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(25.0),
                                        //         borderSide: const BorderSide(
                                        //           color: Colors.blueGrey,
                                        //           width: 2.0,
                                        //         ),
                                        //       ),
                                        //       focusedErrorBorder:
                                        //           OutlineInputBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(25.0),
                                        //         borderSide: const BorderSide(
                                        //           color: Colors.red,
                                        //           width: 2.0,
                                        //         ),
                                        //       ),
                                        //       errorBorder: OutlineInputBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(25.0),
                                        //         borderSide: const BorderSide(
                                        //           color: Colors.red,
                                        //           width: 2.0,
                                        //         ),
                                        //       ),
                                        //       contentPadding:
                                        //           const EdgeInsets.symmetric(
                                        //               horizontal: 20,
                                        //               vertical: 20),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Não"),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      FlatButton(
                                        child: Text("Sim"),
                                        onPressed: () async {
                                          if (obito.date != null &&
                                              // obito.data != null &&
                                              obito.cause != null) {
                                            obito.id = widget.curPatient.cpf;
                                            Box<Obito> obitos =
                                                Hive.box<Obito>('obitos');
                                            obitos.put(
                                                widget.curPatient.cpf, obito);
                                            Box<Patient> patients =
                                                Hive.box<Patient>('patients');
                                            widget.curPatient.death = true;
                                            await patients.put(
                                                widget.curPatient.cpf,
                                                widget.curPatient);
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Home(),
                                                    ),
                                                    (Route<dynamic> route) =>
                                                        false);
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
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
          title: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                // Text(
                //   'Maria dos Prazeres Oliveira',
                //   style: TextStyle(
                //     color: Colors.blue,
                //   ),
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                Hero(
                  tag: widget.curPatient.cpf,
                  child: CircleAvatar(
                    backgroundImage: widget.curPatient.image == 'bolo'
                        ? AssetImage('assets/images/genericAvatar.png')
                        : FileImage(
                            File(widget.curPatient.image),
                          ),
                    radius: 100,
                  ),
                )
              ],
            ),
          ),
          toolbarHeight: 260,
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "Dados",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Tab(
                child: Text(
                  "Exames",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Tab(
                child: Text(
                  "Acompanhamento",
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                  ),
                  child: Text(
                    "NOME:",
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Text(
                        widget.curPatient.name ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 20,
                  ),
                  child: Text(
                    "DATA DE NASCIMENTO:",
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Text(
                        widget.curPatient.dateBirthday ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 20,
                  ),
                  child: Text(
                    "CPF:",
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Text(
                        widget.curPatient.cpf ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 20,
                  ),
                  child: Text(
                    "CARTÃO SUS:",
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Text(
                        widget.curPatient.susCard ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 20,
                  ),
                  child: Text(
                    "NOME DA MÃE:",
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Text(
                        widget.curPatient.motherName ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 20,
                  ),
                  child: Text(
                    "AGENTE:",
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Text(
                        widget.curPatient.agentName ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 20,
                  ),
                  child: Text(
                    "EXTRA:",
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Text(
                        widget.curPatient.extraInfo ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 20,
                  ),
                  child: Text(
                    "DOENÇA:",
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Text(
                        widget.curPatient.disease ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 20,
                  ),
                  child: Text(
                    "RISCO:",
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ),
                Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Text(
                        widget.curPatient.risk ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ListView.builder(
              itemCount: exams.length,
              itemBuilder: (context, index) {
                return ExamCard(
                  examType: exams[index],
                  patientCpf: widget.curPatient.cpf,
                );
              },
            ),
            ListView(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 350),
                        pageBuilder: (context, _, __) =>
                            UbsScreen(patientCpf: widget.curPatient.cpf),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 18),
                            child: Text(
                              "UBS",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 18),
                            child: Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.curPatient.disease != 'Diabetes')
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 350),
                          pageBuilder: (context, _, __) => AppointmentScreen(
                              appointmentType: 'CARDIOLOGISTA',
                              patientCpf: widget.curPatient.cpf),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 18),
                              child: Text(
                                "CARDIOLOGISTA",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 18),
                              child: Icon(Icons.arrow_forward),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (widget.curPatient.disease != 'Hipertensão')
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 350),
                          pageBuilder: (context, _, __) => AppointmentScreen(
                              appointmentType: 'ENDOCRINOLOGISTA',
                              patientCpf: widget.curPatient.cpf),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 18),
                              child: Text(
                                "ENDOCRINOLOGISTA",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 18),
                              child: Icon(Icons.arrow_forward),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 350),
                        pageBuilder: (context, _, __) => HospitalizationScreen(
                          curPatient: widget.curPatient,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 18),
                            child: Text(
                              "INTERNAÇÕES",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 18),
                            child: Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.curPatient.death)
                  Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ExpansionTile(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 5),
                              child: Text(
                                  "Data: ${Hive.box<Obito>('obitos').get(widget.curPatient.cpf).date}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 5, bottom: 15),
                              child: Text(
                                  'Causa: ${Hive.box<Obito>('obitos').get(widget.curPatient.cpf).cause}'),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       left: 16, right: 16, top: 5, bottom: 8),
                            //   child: Text(
                            //       'Dados: ${Hive.box<Obito>('obitos').get(widget.curPatient.cpf).data}'),
                            // ),
                          ],
                        ),
                      ],
                      title: Text("ÓBITO"),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

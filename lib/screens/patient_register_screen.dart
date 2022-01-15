import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiperdia/components/custom_text_field.dart';
import 'package:hiperdia/components/image_source_sheet.dart';
import 'package:hiperdia/models/Agent.dart';
import 'package:hiperdia/models/Patient.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

List<String> agents = [];

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({Key key}) : super(key: key);

  @override
  State<PatientRegisterScreen> createState() => _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  FocusNode myFocusNode;
  FocusNode myFocusNode2;
  FocusNode myFocusNode3;
  FocusNode myFocusNode4;
  FocusNode myFocusNode5;
  @override
  void initState() {
    // TODO: implement initState
    myFocusNode = FocusNode();
    myFocusNode2 = FocusNode();
    myFocusNode3 = FocusNode();
    myFocusNode4 = FocusNode();
    myFocusNode5 = FocusNode();
    agents.clear();
    for (int i = 0; i < Hive.box<Agent>("agents").length; i++) {
      agents.add(Hive.box<Agent>("agents").getAt(i).name);
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myFocusNode.dispose();
    myFocusNode2.dispose();
    myFocusNode3.dispose();
    myFocusNode4.dispose();
    myFocusNode5.dispose();
    super.dispose();
  }

  var maskFormatter = new MaskTextInputFormatter(
      mask: '### #### #### ####', filter: {"#": RegExp(r'[0-9]')});

  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool agentCheck = false;
  bool diseaseCheck = false;
  bool riskCheck = false;
  String agentValue;
  String riskValue;
  String diseaseValue;

  var _valore = ['Baixo', 'Médio', 'Alto', 'Muito Alto'];
  List<String> diseases = ['Diabetes', 'Hipertensão', 'Diabetes e Hipertensão'];
  Patient newPatient = Patient();
  bool hasImage = false;
  File fileActual;

  void onFormSubmit(BuildContext context) {
    if (formKey2.currentState.validate()) {
      if (hasImage && fileActual != null) {
        setState(() {
          newPatient.image = fileActual.path;
        });
      } else {
        setState(() {
          newPatient.image = "bolo";
        });
      }

      if (agentCheck && riskCheck && diseaseCheck) {
        newPatient.hospitalization = false;
        newPatient.death = false;
        Box<Patient> patients = Hive.box<Patient>('patients');
        patients.put(newPatient.cpf, newPatient);
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
    }
  }

  void onImageSelected(File file) {
    setState(() {
      fileActual = file;
      hasImage = true;
    });

    Navigator.of(context).pop();
  }

  void onImageDeleted() {
    setState(() {
      hasImage = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Paciente"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey2,
        child: ListView(
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10),
            //   child: CircleAvatar(
            //     radius: 80,
            //     backgroundColor: Theme.of(context).primaryColor,
            //     child: const Icon(
            //       Icons.add_a_photo,
            //       color: Colors.white,
            //       size: 50,
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                // Align(
                //   alignment: Alignment.center,
                //   child: Expanded(
                //     flex: 0,
                //     child: SvgPicture.asset(
                //       "assets/ic_register.svg",
                //       height: 200,
                //       fit: BoxFit.fitHeight,
                //     ),
                //   ),
                // ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => ImageSourceSheet(
                          onImageSelected: onImageSelected,
                          onImageDeleted: onImageDeleted,
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: hasImage
                          ? CircleAvatar(
                              radius: 80,
                              backgroundImage: FileImage(fileActual),
                            )
                          : Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 50,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            // const CustomTextField(
            //     hintText: 'Rosário de Melo Neves', label: 'Nome'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextFormField(
                validator: (name) {
                  if (name.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (name.trim().split(' ').length <= 1) {
                    return 'Preencha seu Nome completo';
                  }

                  return null;
                },
                onChanged: (name) {
                  setState(() {
                    newPatient.name = name;
                  });
                },
                onEditingComplete: () {
                  myFocusNode.requestFocus();
                },
                decoration: InputDecoration(
                  hintText: 'Rosário de Melo Neves',
                  label: const Text('Nome'),
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            // const CustomTextField(
            //     hintText: '19/08/1995', label: 'Data de Nascimento'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextFormField(
                focusNode: myFocusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  DataInputFormatter(),
                ],
                validator: (birthday) {
                  if (birthday.isEmpty) return 'Campo obrigatório';
                  return null;
                },
                onChanged: (birthday) {
                  setState(() {
                    newPatient.dateBirthday = birthday;
                  });
                },
                onEditingComplete: () {
                  myFocusNode2.requestFocus();
                },
                decoration: InputDecoration(
                  hintText: '19/08/1995',
                  label: const Text('Data de Nascimento'),
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            // const CustomTextField(hintText: '424.341.142-41', label: 'CPF'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextFormField(
                focusNode: myFocusNode2,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter(),
                ],
                validator: (cpf) {
                  if (cpf.isEmpty) return 'Campo obrigatório';
                  return null;
                },
                onChanged: (cpf) {
                  setState(() {
                    newPatient.cpf = cpf;
                  });
                },
                onEditingComplete: () {
                  myFocusNode3.requestFocus();
                },
                decoration: InputDecoration(
                  hintText: '424.341.142-41',
                  label: const Text('CPF'),
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            // const CustomTextField(
            //     hintText: '898 0034 0054 0716', label: 'Cartão SUS'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextFormField(
                focusNode: myFocusNode3,
                keyboardType: TextInputType.number,
                inputFormatters: [maskFormatter],
                validator: (susCard) {
                  if (susCard.isEmpty) return 'Campo obrigatório';
                  return null;
                },
                onChanged: (susCard) {
                  setState(() {
                    newPatient.susCard = susCard;
                  });
                },
                onEditingComplete: () {
                  myFocusNode4.requestFocus();
                },
                decoration: InputDecoration(
                  hintText: '898 0034 0054 0716',
                  label: const Text('Cartão SUS'),
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            // const CustomTextField(
            //     hintText: 'Benedita de Melo Neves', label: 'Nome da mãe'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextFormField(
                focusNode: myFocusNode4,
                validator: (motherName) {
                  if (motherName.isEmpty) return 'Campo obrigatório';
                  return null;
                },
                onChanged: (motherName) {
                  setState(() {
                    newPatient.motherName = motherName;
                  });
                },
                onEditingComplete: () {
                  myFocusNode5.requestFocus();
                },
                decoration: InputDecoration(
                  hintText: 'Benedita de Melo Neves',
                  label: const Text('Nome da mãe'),
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blueGrey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    focusNode: myFocusNode5,
                    value: agentValue,
                    borderRadius: BorderRadius.circular(25),
                    hint: Text('Agente'),
                    isExpanded: true,
                    //borderRadius: BorderRadius.circular(10),
                    elevation: 0,
                    items: agents.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String novoItemSelecionado) {
                      setState(() {
                        agentValue = novoItemSelecionado;
                        newPatient.agentName = novoItemSelecionado;
                        agentCheck = true;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextFormField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                validator: (extraInfo) {
                  if (extraInfo.isEmpty) return 'Campo obrigatório';
                  return null;
                },
                onChanged: (extraInfo) {
                  setState(() {
                    newPatient.extraInfo = extraInfo;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Infromações extra',
                  label: const Text('Extra'),
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blueGrey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: diseaseValue,
                    borderRadius: BorderRadius.circular(25),
                    hint: Text('Doença'),
                    isExpanded: true,
                    //borderRadius: BorderRadius.circular(10),
                    elevation: 0,
                    items: diseases.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String novoItemSelecionado) {
                      setState(() {
                        diseaseValue = novoItemSelecionado;
                        newPatient.disease = novoItemSelecionado;
                        diseaseCheck = true;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blueGrey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: riskValue,
                    borderRadius: BorderRadius.circular(25),
                    hint: Text('Risco'),
                    isExpanded: true,
                    //borderRadius: BorderRadius.circular(10),
                    elevation: 0,
                    items: _valore.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String novoItemSelecionado) {
                      setState(() {
                        riskValue = novoItemSelecionado;
                        newPatient.risk = novoItemSelecionado;
                        riskCheck = true;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                  onFormSubmit(context);
                },
                child: Text('Registar Paciente'),
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

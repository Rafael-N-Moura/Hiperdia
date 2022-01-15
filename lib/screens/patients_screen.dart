import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hiperdia/components/patient_card.dart';
import 'package:hiperdia/models/Patient.dart';
import 'package:hiperdia/screens/patient_screen.dart';
import 'package:hiperdia/screens/report_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({Key key}) : super(key: key);

  @override
  _PatientsScreenState createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  bool hipertenso_control = false;
  bool hospitalizado_control = false;
  bool obito_control = false;
  bool diabetico_control = false;
  bool dh_control = false;
  bool searchMode = false;
  String search;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pacientes"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 350),
                    pageBuilder: (context, _, __) => ReportScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.document_scanner),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
              child: TextFormField(
                onChanged: (name) {
                  setState(() {
                    search = name;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        searchMode = !searchMode;
                      });
                    },
                    child: Container(
                      child: searchMode
                          ? Icon(Icons.cancel_rounded, color: Colors.white)
                          : Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  hintText: 'Rosário de Melo Neves',
                  label: const Text('Pesquisar'),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(25.0),
                    //   bottomLeft: Radius.circular(25.0),
                    // ),
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
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
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 5),
            //   //  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            //   height: size.height * 0.06,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20),
            //     color: Colors.white,
            //     border: Border.all(color: Colors.grey),
            //   ),
            //   child: Row(
            //     children: [
            //       SizedBox(
            //         width: 10,
            //       ),
            //       Icon(Icons.search, color: Colors.grey),
            //       SizedBox(
            //         width: 10,
            //       ),
            //       Text(
            //         "Pesquisar",
            //         style: TextStyle(color: Colors.grey),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              //margin: EdgeInsets.symmetric(horizontal: 40),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  //alignment: WrapAlignment.spaceEvenly,
                  //verticalDirection: VerticalDirection.up,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            diabetico_control = !diabetico_control;
                            dh_control = false;
                            hipertenso_control = false;
                            obito_control = false;
                            hospitalizado_control = false;
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: diabetico_control
                              ? Colors.blue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          "Diabéticos",
                          style: TextStyle(
                            color:
                                diabetico_control ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          dh_control = !dh_control;
                          diabetico_control = false;
                          hipertenso_control = false;
                          obito_control = false;
                          hospitalizado_control = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: dh_control ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          "Diabéticos e Hipertensos",
                          style: TextStyle(
                            color: dh_control ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          hipertenso_control = !hipertenso_control;
                          dh_control = false;
                          diabetico_control = false;
                          hospitalizado_control = false;
                          obito_control = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: hipertenso_control
                              ? Colors.blue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          "Hipertensos",
                          style: TextStyle(
                            color: hipertenso_control
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          hospitalizado_control = !hospitalizado_control;
                          dh_control = false;
                          diabetico_control = false;
                          hipertenso_control = false;
                          obito_control = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: hospitalizado_control
                              ? Colors.blue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          "Hospitalizados",
                          style: TextStyle(
                            color: hospitalizado_control
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          obito_control = !obito_control;
                          hospitalizado_control = false;
                          dh_control = false;
                          diabetico_control = false;
                          hipertenso_control = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color:
                              obito_control ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          "Óbitos",
                          style: TextStyle(
                            color: obito_control ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 40),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Container(
              height: size.height * 0.55,
              child: ValueListenableBuilder(
                  valueListenable: Hive.box<Patient>("patients").listenable(),
                  builder: (context, Box<Patient> box, _) {
                    if (box.values.isEmpty)
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/without_patient.svg",
                            height: size.height * 0.4,
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
                        Patient p = box.getAt(index);
                        print(p.name);
                        print(p.image);

                        if (searchMode) {
                          if (search == null) {
                            return Container();
                          }
                          if (p.name
                              .toUpperCase()
                              .contains(search.toUpperCase())) {
                            return PatientCard(
                              curPatient: p,
                            );
                          } else {
                            return Container();
                          }
                        }

                        if (diabetico_control) {
                          if (p.disease == 'Diabetes') {
                            return PatientCard(
                              curPatient: p,
                            );
                          } else {
                            return Container();
                          }
                        }
                        if (hipertenso_control) {
                          if (p.disease == 'Hipertensão') {
                            return PatientCard(
                              curPatient: p,
                            );
                          } else {
                            return Container();
                          }
                        }
                        if (dh_control) {
                          if (p.disease == 'Diabetes e Hipertensão') {
                            return PatientCard(
                              curPatient: p,
                            );
                          } else {
                            return Container();
                          }
                        }
                        if (hospitalizado_control) {
                          if (p.hospitalization) {
                            return PatientCard(
                              curPatient: p,
                            );
                          } else {
                            return Container();
                          }
                        }
                        if (obito_control) {
                          if (p.death) {
                            return PatientCard(
                              curPatient: p,
                            );
                          } else {
                            return Container();
                          }
                        }

                        return PatientCard(
                          curPatient: p,
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

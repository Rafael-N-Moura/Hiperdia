import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hiperdia/components/custom_text_field.dart';
import 'package:hiperdia/components/image_source_sheet.dart';
import 'package:hiperdia/models/Agent.dart';

class AgentRegisterScreen extends StatefulWidget {
  const AgentRegisterScreen({Key key}) : super(key: key);

  @override
  State<AgentRegisterScreen> createState() => _AgentRegisterScreenState();
}

class _AgentRegisterScreenState extends State<AgentRegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //Agent agent = Agent();
  String nameAgent;
  String teamAgent;
  String areaAgent;
  String imageAgent = 'bolo';
  bool hasImage = false;
  File fileActual;
  FocusNode myFocusNode;
  FocusNode myFocusNode2;

  @override
  void initState() {
    // TODO: implement initState
    myFocusNode = FocusNode();
    myFocusNode2 = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    myFocusNode.dispose();
    myFocusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onFormSubmit() {
      print(nameAgent);
      if (formKey.currentState.validate()) {
        if (hasImage && fileActual != null) {
          setState(() {
            imageAgent = fileActual.path;
          });
        } else {
          setState(() {
            imageAgent = "bolo";
          });
        }
        Box<Agent> agents = Hive.box<Agent>('agents');
        agents.add(Agent(
            name: nameAgent,
            team: teamAgent,
            area: areaAgent,
            image: imageAgent));
        Navigator.of(context).pop();
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Agente"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
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
            //   hintText: 'Benedito dos Santos Silva',
            //   label: 'Nome',
            //   onSaved: (name) => sa,
            // ),
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
                    nameAgent = name;
                  });
                },
                onEditingComplete: () {
                  myFocusNode.requestFocus();
                },
                decoration: InputDecoration(
                  hintText: 'Benedito dos Santos Silva',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextFormField(
                focusNode: myFocusNode,
                validator: (area) {
                  if (area.isEmpty) return 'Campo obrigatório';
                  return null;
                },
                onChanged: (area) {
                  setState(() {
                    areaAgent = area;
                  });
                },
                onEditingComplete: () {
                  myFocusNode2.requestFocus();
                },
                decoration: InputDecoration(
                  hintText: 'Campo de Belém',
                  label: const Text('Área'),
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
              child: TextFormField(
                focusNode: myFocusNode2,
                validator: (equipe) {
                  if (equipe.isEmpty) return 'Campo obrigatório';
                  return null;
                },
                onChanged: (team) {
                  setState(() {
                    teamAgent = team;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Equipe',
                  label: const Text('Equipe'),
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
            // const CustomTextField(hintText: '19/08/1995', label: 'Área'),
            // const CustomTextField(hintText: '424.341.142-41', label: 'CPF'),
            // const CustomTextField(
            //     hintText: '898 0034 0054 0716', label: 'Equipe'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                onPressed: onFormSubmit,
                child: const Text('Registar Agente'),
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

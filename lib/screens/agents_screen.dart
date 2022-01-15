import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hiperdia/components/agent_card.dart';
import 'package:hiperdia/models/Agent.dart';
import 'package:hiperdia/screens/patient_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class AgentsScreen extends StatefulWidget {
  const AgentsScreen({Key key}) : super(key: key);

  @override
  _AgentsScreenState createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Agentes"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Agent>("agents").listenable(),
        builder: (context, Box<Agent> box, _) {
          if (box.values.isEmpty)
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/without_Data2.svg",
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
              Agent a = box.getAt(index);
              print(a.name);
              print(a.image);
              return AgentCard(
                name: a.name,
                team: a.team,
                area: a.area,
                image: a.image,
              );
            },
          );
        },
      ),
    );
  }
}

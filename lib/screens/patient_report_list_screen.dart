import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hiperdia/components/agent_card.dart';
import 'package:hiperdia/models/Agent.dart';
import 'package:hiperdia/models/PatientReport.dart';
import 'package:hiperdia/screens/patient_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import '../components/report_card.dart';

class PatientReportScreen extends StatefulWidget {
  const PatientReportScreen({Key key}) : super(key: key);

  @override
  _PatientReportScreenState createState() => _PatientReportScreenState();
}

class _PatientReportScreenState extends State<PatientReportScreen> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatórios"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable:
            Hive.box<PatientReport>("patient_reports").listenable(),
        builder: (context, Box<PatientReport> box, _) {
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
              PatientReport a = box.getAt(index);
              return ReportCard(
                name: a.name,
                path: a.path,
                date:
                    "${a.date.day.toString().padLeft(2, '0')}/${a.date.month.toString().padLeft(2, '0')}/${a.date.year}",
              );
            },
          );
        },
      ),
    );
  }
}

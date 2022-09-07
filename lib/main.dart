import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hiperdia/models/Agent.dart';
import 'package:hiperdia/models/Appointment.dart';
import 'package:hiperdia/models/Exam.dart';
import 'package:hiperdia/models/Hospitalization.dart';
import 'package:hiperdia/models/Obito.dart';
import 'package:hiperdia/models/Patient.dart';
import 'package:hiperdia/models/PatientReport.dart';
import 'package:hiperdia/models/Ubs.dart';
import 'package:hiperdia/screens/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

const String agentsBoxName = "agents";
const String patientsBoxName = "patients";
const String obitosBoxName = "obitos";
const String examsBoxName = "exams";
const String appointmentBoxName = "appointments";
const String hospitalizationBoxName = "hospitalizations";
const String ubsBoxName = "ubs";
const String patientReportBoxName = "patient_reports";

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Agent>(AgentAdapter());
  Hive.registerAdapter<Patient>(PatientAdapter());
  Hive.registerAdapter<Obito>(ObitoAdapter());
  Hive.registerAdapter<Exam>(ExamAdapter());
  Hive.registerAdapter<Appointment>(AppointmentAdapter());
  Hive.registerAdapter<Hospitalization>(HospitalizationAdapter());
  Hive.registerAdapter<Ubs>(UbsAdapter());
  Hive.registerAdapter<PatientReport>(PatientReportAdapter());
  await Hive.openBox<Agent>(agentsBoxName);
  await Hive.openBox<Patient>(patientsBoxName);
  await Hive.openBox<Obito>(obitosBoxName);
  await Hive.openBox<Exam>(examsBoxName);
  await Hive.openBox<Appointment>(appointmentBoxName);
  await Hive.openBox<Hospitalization>(hospitalizationBoxName);
  await Hive.openBox<Ubs>(ubsBoxName);
  await Hive.openBox<PatientReport>(patientReportBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [
        const Locale('pt', 'BR'),
        const Locale('en'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Hiperdia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

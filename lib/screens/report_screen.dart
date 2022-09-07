import 'dart:io';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:hiperdia/models/Appointment.dart';
import 'package:hiperdia/models/Exam.dart';
import 'package:hiperdia/models/Hospitalization.dart';
import 'package:hiperdia/models/Obito.dart';
import 'package:hiperdia/models/Patient.dart';
import 'package:hiperdia/models/PatientReport.dart';
import 'package:hiperdia/models/Ubs.dart';
import 'package:hiperdia/screens/patient_report_list_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Patient> hipertensos = [];
    List<Patient> diabeticos = [];
    List<Patient> diabeticosHipertensos = [];
    List<Hospitalization> hospitalizations = [];
    List<Obito> obitos = [];
    List<Ubs> ubs = [];
    List<Appointment> appointments = [];
    List<Exam> exams = [];

    Box<Patient> patients = Hive.box<Patient>('patients');
    Box<Hospitalization> hospitalizationBox =
        Hive.box<Hospitalization>('hospitalizations');
    Box<Obito> obitosBox = Hive.box<Obito>('obitos');
    Box<Ubs> ubsBox = Hive.box<Ubs>('ubs');
    Box<Appointment> appointmentBox = Hive.box<Appointment>('appointments');
    Box<Exam> examBox = Hive.box<Exam>('exams');
    Box<PatientReport> patientReportBox =
        Hive.box<PatientReport>('patient_reports');

    void addReport(String name, String path, DateTime date) {
      patientReportBox.add(PatientReport(name: name, path: path, date: date));
    }

    void reportHipertensos() async {
      hipertensos.clear();

      if (patients.isNotEmpty) {
        for (var key in patients.keys) {
          Patient p = patients.get(key);
          if (p.disease == "Hipertensão") {
            hipertensos.add(p);
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem registros de pacientes',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      if (hipertensos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem registros de pacientes hipertensos',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          // header: (pw.Context context) {
          //   if (context.pageNumber == 1) {
          //     return null;
          //   }
          //   return pw.Container(
          //       alignment: pw.Alignment.centerRight,
          //       margin: pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          //       padding: pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          //       // decoration: BoxDecoration(
          //       //     border: BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)
          //       // ),
          //       child: pw.Text('Hiperdia App',
          //           style: pw.Theme.of(context)
          //               .defaultTextStyle
          //               .copyWith(color: PdfColors.grey)));
          // },
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text(
                      'HIPERTENSOS',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  if (hipertensos.isNotEmpty)
                    for (int i = 0; i < hipertensos.length; i++)
                      patientDescription(hipertensos[i]),
                ],
              ),
            ]; // Center
          },
        ),
      ); // Pageageage

      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        //add more permission to request here.
      ].request();

      if (statuses[Permission.storage].isGranted) {
        //final output = await getExternalStorageDirectory();
        final output = await DownloadsPathProvider.downloadsDirectory;
        String path =
            "${output.path}/hipertensos-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}-${DateTime.now().millisecond}.pdf";
        final file = File(path);
        print(
            "${output.path}/hipertensos-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}-${DateTime.now().millisecond}.pdf");
        await file.writeAsBytes(await pdf.save());
        addReport('Hipertensos', path, DateTime.now());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Relatório gerado com sucesso',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem permissão para gerar o relatório',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    void reportDiabeticos() async {
      diabeticos.clear();

      if (patients.isNotEmpty) {
        for (var key in patients.keys) {
          Patient p = patients.get(key);
          if (p.disease == "Diabetes") {
            diabeticos.add(p);
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem registros de pacientes',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      if (diabeticos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem registros de pacientes diabéticos',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text(
                      'DIABÉTICOS',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  if (diabeticos.isNotEmpty)
                    for (int i = 0; i < diabeticos.length; i++)
                      patientDescription(diabeticos[i]),
                ],
              ),
            ]; // Center
          },
        ),
      ); // Pageageage
      //final output = await getExternalStorageDirectory();
      final output = await DownloadsPathProvider.downloadsDirectory;
      String path =
          "${output.path}/diabeticos-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}-${DateTime.now().millisecond}.pdf";
      final file = File(path);
      await file.writeAsBytes(await pdf.save());
      addReport('Diabéticos', path, DateTime.now());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Relatório gerado com sucesso',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
    }

    void reportDiabeticosHipertensos() async {
      diabeticosHipertensos.clear();

      if (patients.isNotEmpty) {
        for (var key in patients.keys) {
          Patient p = patients.get(key);
          if (p.disease == "Diabetes e Hipertensão") {
            diabeticosHipertensos.add(p);
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem registros de pacientes',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      if (diabeticosHipertensos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem registros de pacientes que são diabéticos e hipertensos',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text(
                      'DIABÉTICOS\nE\nHIPERTENSOS',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  if (diabeticosHipertensos.isNotEmpty)
                    for (int i = 0; i < diabeticosHipertensos.length; i++)
                      patientDescription(diabeticosHipertensos[i]),
                ],
              ),
            ]; // Center
          },
        ),
      ); // Pageageage
      //final output = await getExternalStorageDirectory();
      final output = await DownloadsPathProvider.downloadsDirectory;
      String path =
          "${output.path}/diabeticosEhipertensos-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}-${DateTime.now().millisecond}.pdf";
      final file = File(path);
      await file.writeAsBytes(await pdf.save());
      addReport('Diabéticos e Hipertensos', path, DateTime.now());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Relatório gerado com sucesso',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
    }

    void reportHospitalizations() async {
      hospitalizations.clear();

      if (hospitalizationBox.isNotEmpty) {
        for (var key in hospitalizationBox.keys) {
          Hospitalization h = hospitalizationBox.get(key);
          hospitalizations.add(h);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem registros de hospitalizações',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text(
                      'HOSPITALIZAÇÕES',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  if (hospitalizations.isNotEmpty)
                    for (int i = 0; i < hospitalizations.length; i++)
                      hospitalizationDescription(hospitalizations[i],
                          patients.get(hospitalizations[i].id).name),
                ],
              ),
            ]; // Center
          },
        ),
      ); // Pageageage
      //final output = await getExternalStorageDirectory();
      final output = await DownloadsPathProvider.downloadsDirectory;
      final file = File(
          "${output.path}/hospitalizacoes-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}-${DateTime.now().millisecond}.pdf");
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Relatório gerado com sucesso',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
    }

    void reportObitos() async {
      obitos.clear();

      if (obitosBox.isNotEmpty) {
        for (var key in obitosBox.keys) {
          Obito o = obitosBox.get(key);
          obitos.add(o);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem registros de óbitos',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text(
                      'ÓBITOS',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  if (obitos.isNotEmpty)
                    for (int i = 0; i < obitos.length; i++)
                      obitoDescription(
                          obitos[i], patients.get(obitos[i].id).name),
                ],
              ),
            ]; // Center
          },
        ),
      ); // Pageageage
      //final output = await getExternalStorageDirectory();
      final output = await DownloadsPathProvider.downloadsDirectory;
      String path =
          "${output.path}/obitos-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}-${DateTime.now().millisecond}.pdf";
      final file = File(path);
      await file.writeAsBytes(await pdf.save());
      addReport('Óbitos', path, DateTime.now());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Relatório gerado com sucesso',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
    }

    void reportUbs() async {
      ubs.clear();

      if (ubsBox.isNotEmpty) {
        for (var key in ubsBox.keys) {
          Ubs u = ubsBox.get(key);
          ubs.add(u);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem registros de consultas na UBS',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text(
                      'UBS',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  if (ubs.isNotEmpty)
                    for (int i = 0; i < ubs.length; i++)
                      ubsDescription(ubs[i], patients.get(ubs[i].id).name),
                ],
              ),
            ]; // Center
          },
        ),
      ); // Pageageage
      //final output = await getExternalStorageDirectory();
      final output = await DownloadsPathProvider.downloadsDirectory;
      final file = File(
          "${output.path}/ubs-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}-${DateTime.now().millisecond}.pdf");
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Relatório gerado com sucesso',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
    }

    void reportAppointment() async {
      appointments.clear();

      if (appointmentBox.isNotEmpty) {
        for (var key in appointmentBox.keys) {
          Appointment a = appointmentBox.get(key);
          appointments.add(a);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem registros de consultas',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text(
                      'CONSULTAS',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  if (appointments.isNotEmpty)
                    for (int i = 0; i < appointments.length; i++)
                      appointmentDescription(appointments[i],
                          patients.get(appointments[i].id).name),
                ],
              ),
            ]; // Center
          },
        ),
      ); // Pageageage
      //final output = await getExternalStorageDirectory();
      final output = await DownloadsPathProvider.downloadsDirectory;
      String path =
          "${output.path}/consultas-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}-${DateTime.now().millisecond}.pdf";
      final file = File(path);
      await file.writeAsBytes(await pdf.save());
      addReport('Ubs', path, DateTime.now());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Relatório gerado com sucesso',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
    }

    void reportExams() async {
      exams.clear();

      if (examBox.isNotEmpty) {
        for (var key in examBox.keys) {
          Exam e = examBox.get(key);
          exams.add(e);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sem registros de exames',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Text(
                      'EXAMES',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  if (exams.isNotEmpty)
                    for (int i = 0; i < exams.length; i++)
                      examDescription(exams[i], patients.get(exams[i].id).name),
                ],
              ),
            ]; // Center
          },
        ),
      ); // Pageageage
      //final output = await getExternalStorageDirectory();
      final output = await DownloadsPathProvider.downloadsDirectory;
      String path =
          "${output.path}/exames-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}-${DateTime.now().millisecond}.pdf";
      final file = File(path);
      await file.writeAsBytes(await pdf.save());
      addReport('Exames', path, DateTime.now());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Relatório gerado com sucesso',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text("Gerar relatórios"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 350),
                      pageBuilder: (context, _, __) =>
                          const PatientReportScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.folder)),
          ]),
      body: ListView(children: [
        GestureDetector(
          onTap: () async {
            reportHipertensos();
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      "RELATÓRIO HIPERTENSOS",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    child: Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            reportDiabeticos();
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      "RELATÓRIO DIABÉTICOS",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    child: Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            reportDiabeticosHipertensos();
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      "RELATÓRIO DIABÉTICOS E \nHIPERTENSOS",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    child: Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            reportHospitalizations();
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      "RELATÓRIO HOSPITALIZAÇÕES",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    child: Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            reportObitos();
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      "RELATÓRIO ÓBITOS",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    child: Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            reportUbs();
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      "RELATÓRIO UBS",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    child: Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            reportAppointment();
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      "RELATÓRIO CONSULTAS",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    child: Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            reportExams();
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      "RELATÓRIO EXAMES",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    child: Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

patientDescription(Patient p) {
  return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(),
        pw.Divider(),
        pw.Text(
          p.name,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text('Data de Nascimento: ${p.dateBirthday}'),
        pw.SizedBox(height: 10),
        pw.Text('CPF: ${p.cpf}'),
        pw.SizedBox(height: 10),
        pw.Text('Cartão SUS: ${p.susCard}'),
        pw.SizedBox(height: 10),
        pw.Text('Nome da Mãe: ${p.motherName}'),
        pw.SizedBox(height: 10),
        pw.Text('Agente: ${p.agentName}'),
        pw.SizedBox(height: 10),
        pw.Text('Informações Extras: ${p.extraInfo}'),
        pw.SizedBox(height: 10),
        pw.Text('Risco: ${p.risk}'),
      ]);
}

hospitalizationDescription(Hospitalization h, String patientName) {
  return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(),
        pw.Divider(),
        pw.Text(
          patientName,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text('Local: ${h.place}'),
        pw.SizedBox(height: 10),
        pw.Text('Causa: ${h.cause}'),
        pw.SizedBox(height: 10),
        pw.Text('Data da Internação: ${h.dateStart}'),
        pw.SizedBox(height: 10),
        if (h.dateEnd != null) pw.Text('Nome da Alta: ${h.dateEnd}'),
        pw.SizedBox(height: 10),
      ]);
}

obitoDescription(Obito o, String patientName) {
  return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(),
        pw.Divider(),
        pw.Text(
          patientName,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text('Data: ${o.date}'),
        pw.SizedBox(height: 10),
        pw.Text('Causa: ${o.cause}'),
        pw.SizedBox(height: 10),
        // pw.Text('Dados: ${o.data}'),
        // pw.SizedBox(height: 10),
      ]);
}

ubsDescription(Ubs u, String patientName) {
  return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(),
        pw.Divider(),
        pw.Text(
          patientName,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text('Data: ${u.date}'),
        pw.SizedBox(height: 10),
        pw.Text('Profissional: ${u.professional}'),
        pw.SizedBox(height: 10),
        pw.Text('Nome do Profissional: ${u.professionalName}'),
        pw.SizedBox(height: 10),
        pw.Text('Local: ${u.place}'),
        pw.SizedBox(height: 10),
      ]);
}

appointmentDescription(Appointment a, String patientName) {
  return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(),
        pw.Divider(),
        pw.Text(
          patientName,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text('Tipo: ${a.type}'),
        pw.SizedBox(height: 10),
        pw.Text('Data: ${a.date}'),
        pw.SizedBox(height: 10),
        pw.Text('Local: ${a.place}'),
        pw.SizedBox(height: 10),
        pw.Text('Médico: ${a.doctorName}'),
        pw.SizedBox(height: 10),
      ]);
}

examDescription(Exam e, String patientName) {
  return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(),
        pw.Divider(),
        pw.Text(
          patientName,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text('Tipo: ${e.type}'),
        pw.SizedBox(height: 10),
        pw.Text('Data: ${e.date}'),
        pw.SizedBox(height: 10),
        pw.Text('Resultados: ${e.results}'),
        pw.SizedBox(height: 10),
      ]);
}

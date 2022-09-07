import 'package:hiperdia/models/Patient.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'PatientReport.g.dart';

// ignore: file_names
@HiveType(typeId: 7)
class PatientReport {
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String path;
  PatientReport({
    this.name,
    this.date,
    this.path,
  });

  @override
  String toString() => 'PatientReport(name: $name, date: $date, path: $path)';
}

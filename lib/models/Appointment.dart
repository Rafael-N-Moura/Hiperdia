import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

part 'Appointment.g.dart';

// ignore: file_names
@HiveType(typeId: 4)
class Appointment {
  @HiveField(0)
  String id;

  @HiveField(1)
  String type;

  @HiveField(2)
  String date;

  @HiveField(3)
  String doctorName;

  @HiveField(4)
  String place;
}

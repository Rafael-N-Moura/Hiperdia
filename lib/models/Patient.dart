import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'Patient.g.dart';

// ignore: file_names
@HiveType(typeId: 0)
class Patient {
  @HiveField(0)
  String image;

  @HiveField(1)
  String name;

  @HiveField(2)
  String dateBirthday;

  @HiveField(3)
  String cpf;

  @HiveField(4)
  String susCard;

  @HiveField(5)
  String motherName;

  @HiveField(6)
  String agentName;

  @HiveField(7)
  String extraInfo;

  @HiveField(8)
  String disease;

  @HiveField(9)
  String risk;

  @HiveField(10)
  bool hospitalization;

  @HiveField(11)
  bool death;

  Patient({
    this.image,
    this.name,
    this.dateBirthday,
    this.cpf,
    this.susCard,
    this.motherName,
    this.agentName,
    this.extraInfo,
    this.disease,
    this.risk,
    this.hospitalization,
    this.death,
  });
}

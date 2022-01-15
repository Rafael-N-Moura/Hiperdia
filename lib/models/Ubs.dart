import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'Ubs.g.dart';

// ignore: file_names
@HiveType(typeId: 6)
class Ubs {
  @HiveField(0)
  String date;

  @HiveField(1)
  String professional;

  @HiveField(2)
  String professionalName;

  @HiveField(3)
  String place;

  @HiveField(4)
  String id;

  Ubs({
    this.date,
    this.professional,
    this.professionalName,
    this.place,
    this.id,
  });

  @override
  String toString() {
    return 'Ubs(date: $date, professional: $professional, professionalName: $professionalName, place: $place, id: $id)';
  }
}

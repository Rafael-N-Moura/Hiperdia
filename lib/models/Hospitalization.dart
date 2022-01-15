import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'Hospitalization.g.dart';

// ignore: file_names
@HiveType(typeId: 5)
class Hospitalization {
  @HiveField(0)
  String id;

  @HiveField(1)
  String cause;

  @HiveField(2)
  String place;

  @HiveField(3)
  String dateStart;

  @HiveField(4)
  String dateEnd;

  @HiveField(5)
  String key;

  Hospitalization({
    this.id,
    this.cause,
    this.place,
    this.dateStart,
    this.dateEnd,
    this.key,
  });

  @override
  String toString() {
    return 'Hospitalization(id: $id, cause: $cause, place: $place, dateStart: $dateStart, dateEnd: $dateEnd, key: $key)';
  }
}

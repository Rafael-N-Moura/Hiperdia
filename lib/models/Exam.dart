import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'Exam.g.dart';

// ignore: file_names
@HiveType(typeId: 3)
class Exam {
  @HiveField(0)
  String id;

  @HiveField(1)
  String date;

  @HiveField(2)
  String results;

  @HiveField(3)
  String type;

  Exam({
    this.id,
    this.date,
    this.results,
    this.type,
  });

  @override
  String toString() {
    return 'Exam(id: $id, date: $date, results: $results, type: $type)';
  }
}

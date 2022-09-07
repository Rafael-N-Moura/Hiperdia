import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'Obito.g.dart';

// ignore: file_names
@HiveType(typeId: 2)
class Obito {
  @HiveField(0)
  String id;

  @HiveField(1)
  String date;

  @HiveField(2)
  String cause;

  // @HiveField(3)
  // String data;

  Obito({
    this.id,
    this.date,
    this.cause,
    // this.data,
  });
}

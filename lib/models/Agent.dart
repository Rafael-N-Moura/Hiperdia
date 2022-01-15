import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

part 'Agent.g.dart';

// ignore: file_names
@HiveType(typeId: 1)
class Agent {
  @HiveField(0)
  String name;

  @HiveField(1)
  String team;

  @HiveField(2)
  String area;

  @HiveField(3)
  String image;

  Agent({
    this.name,
    this.team,
    this.area,
    this.image,
  });

  @override
  String toString() =>
      'Agent(nome: $name, equipe: $team, area: $area, imagem: $image)';
}

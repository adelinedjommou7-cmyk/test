import 'package:example/models/types.dart';
import 'package:hive/hive.dart';

part 'save_ressource_list.g.dart';

@HiveType(typeId: 2)
class SavedRessourceList {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String image;
  @HiveField(4)
  final List<Types>? type;
  @HiveField(5)
  final String followLink;
  @HiveField(6)
  final String localLink;
  @HiveField(7)
  final String niveau;

  SavedRessourceList({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.type,
    required this.followLink,
    required this.localLink,
    required this.niveau,
  });
}

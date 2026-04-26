import 'package:equatable/equatable.dart';
import 'package:example/models/types.dart';

// ignore: must_be_immutable
class Ressources extends Equatable {
  String? id;
  String? title;
  String? description;
  String? categorie;
  String? image;
  List<Types>? type;
  String? followLink;
  String? localLink;
  List<String>? niveau;

  Ressources(
      {this.id,
      this.title,
      this.description,
      this.categorie,
      this.image,
      this.type,
      this.followLink,
      this.localLink,
      this.niveau});

  Ressources.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    categorie = json['categorie'];
    image = json['image'];
    if (json['type'] != null) {
      type = <Types>[];
      json['type'].forEach((v) {
        type!.add(Types.fromJson(v));
      });
    }
    followLink = json['followLink'];
    localLink = json['localLink'] ?? "";
    niveau = json['niveau'] != null ? List<String>.from(json['niveau']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['categorie'] = categorie;
    data['image'] = image;
    if (type != null) {
      data['type'] = type!.map((v) => v.toJson()).toList();
    }
    data['followLink'] = followLink;
    data['localLink'] = localLink;
    data['niveau'] = niveau;
    return data;
  }

  @override
  List<Object> get props {
    return [
      id!,
      title!,
      description!,
      image!,
      type!,
      followLink!,
      localLink!,
      niveau!
    ];
  }

  Ressources copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    List<Types>? type,
    String? followLink,
    String? localLink,
    List<String>? niveau,
  }) {
    return Ressources(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      type: type ?? this.type!,
      followLink: followLink ?? this.followLink,
      localLink: localLink ?? this.localLink,
      niveau: niveau ?? this.niveau,
    );
  }

  @override
  String toString() =>
      'Ressources(title: $title, description: $description, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ressources &&
        other.title == title &&
        other.description == description &&
        other.type == type;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode ^ type.hashCode;

  Map<String, dynamic> toJsonFromString() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    if (type != null) {
      data['type'] = type!.map((v) => v.toString()).toList().toString();
    }
    data['followLink'] = followLink;
    data['localLink'] = localLink;
    data['niveau'] = niveau;
    return data;
  }

  Ressources.fromJsonToSting(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    json['type'] = Types.toJsonList(json['type']);

    followLink = json['followLink'];
    localLink = json['localLink'] ?? "";
    niveau = json['niveau'] != null ? List<String>.from(json['niveau']) : [];
  }
}

// class Ressources  extends Equatable {
//   @HiveField(0)
//   String? id;
//   @HiveField(1)
//   String? title;
//   @HiveField(2)
//   String? description;
//   @HiveField(3)
//   String? image;
//   @HiveField(4)
//   List<Types>? type;
//   @HiveField(5)
//   String? followLink;
//   @HiveField(6)
//   String? localLink;
//   @HiveField(7)
//   List<String>? niveau;

//   Ressources(
//       {this.id,
//       this.title,
//       this.description,
//       this.image,
//       this.type,
//       this.followLink,
//       this.localLink,
//       this.niveau});

//   Ressources.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     description = json['description'];
//     image = json['image'];
//     // type = json['type'] != null ? new Types.fromJson(json['type']) : null;
//     if (json['type'] != null) {
//       type = <Types>[];
//       json['type'].forEach((v) {
//         type!.add(Types.fromJson(v));
//       });
//     }
//     followLink = json['followLink'];
//     localLink = json['localLink'] ?? "";
//     niveau = json['niveau'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     data['description'] = this.description;
//     data['image'] = this.image;

//     if (type != null) {
//       data['type'] = type!.map((v) => v.toJson()).toList();
//     }
//     data['followLink'] = this.followLink;
//     data['localLink'] = this.localLink;
//     data['niveau'] = this.niveau;
//     return data;
//   }

//   Ressources copyWith({
//     String? id,
//     String? title,
//     String? description,
//     String? image,
//     Types? type,
//     String? followLink,
//   }) {
//     return Ressources(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       image: image ?? this.image,
//       // type: type ?? this.type!,
//       followLink: followLink ?? this.followLink,
//     );
//   }

//   @override
//   String toString() =>
//       'Ressources(title: $title, description: $description, type: $type)';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is Ressources &&
//         other.title == title &&
//         other.description == description &&
//         other.type == type;
//   }

//   @override
//   int get hashCode => title.hashCode ^ description.hashCode ^ type.hashCode;
// }

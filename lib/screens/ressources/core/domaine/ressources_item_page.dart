import 'package:example/models/ressources.dart';
import 'package:example/screens/pagination/paginate.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ressources_item_page.g.dart';

@immutable
@JsonSerializable()
class RessourceItemPaged extends Paginate<Ressources> {
  RessourceItemPaged(
      {List<Ressources>? data,
      bool? hasNext,
      bool? hasPrev,
      int? perPage,
      int? page,
      int? dataCount,
      int? totalPages})
      : super(
            data: data!,
            hasPrev: hasPrev!,
            hasNext: hasNext!,
            totalPages: totalPages!,
            dataCount: dataCount!,
            page: page!,
            perPage: perPage!);

  factory RessourceItemPaged.fromJson(Map<String, dynamic> json) =>
      _$RessourceItemPagedFromJson(json);

  factory RessourceItemPaged.initial() => RessourceItemPaged(
        data: [],
        hasNext: true,
        hasPrev: false,
        page: 0,
        totalPages: 1,
      );

  Map<String, dynamic> toJson() => _$RessourceItemPagedToJson(this);

  RessourceItemPaged update(
      {List<Ressources>? data,
      hasNext,
      page,
      hasPrev,
      totalPages,
      dataCount,
      perPage}) {
    return RessourceItemPaged(
      data: data ?? this.data,
      hasNext: hasNext ?? this.hasNext,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      hasPrev: hasPrev ?? this.hasPrev,
      perPage: perPage ?? this.perPage,
      dataCount: dataCount ?? this.dataCount,
    );
  }

  @override
  String toString() {
    return '''RessourceItemPaged {
      data: $data,
      hasNext: $hasNext,
      page: $page,
      totalPages: $totalPages,
      dataCount: $dataCount,
      hasPrev: $hasPrev,
      perPage: $perPage,
    }''';
  }
}

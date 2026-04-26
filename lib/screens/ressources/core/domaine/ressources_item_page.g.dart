// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ressources_item_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RessourceItemPaged _$RessourceItemPagedFromJson(Map<String, dynamic> json) =>
    RessourceItemPaged(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Ressources.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasNext: json['has_next'] as bool?,
      hasPrev: json['has_prev'] as bool?,
      perPage: (json['per_page'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      dataCount: (json['data_count'] as num?)?.toInt(),
      totalPages: (json['total_pages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RessourceItemPagedToJson(RessourceItemPaged instance) =>
    <String, dynamic>{
      'data': instance.data,
      'has_next': instance.hasNext,
      'has_prev': instance.hasPrev,
      'page': instance.page,
      'per_page': instance.perPage,
      'data_count': instance.dataCount,
      'total_pages': instance.totalPages,
    };

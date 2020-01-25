// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_pojo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdPOJO _$AdPOJOFromJson(Map<String, dynamic> json) {
  return AdPOJO(
      name: json['name'] as String,
      price: (json['price'] as num)?.toDouble(),
      street: json['street'] as String,
      houseNumber: json['houseNumber'] as int,
      apartmentNumber: json['apartmentNumber'] as int,
      city: json['city'] as String,
      zip: json['zip'] as String,
      description: json['description'] as String,
      mainImage: json['mainImage'] as int,
      scope: json['scope'] as String);
}

Map<String, dynamic> _$AdPOJOToJson(AdPOJO instance) => <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'street': instance.street,
      'houseNumber': instance.houseNumber,
      'apartmentNumber': instance.apartmentNumber,
      'city': instance.city,
      'zip': instance.zip,
      'description': instance.description,
      'mainImage': instance.mainImage,
      'scope': instance.scope
    };

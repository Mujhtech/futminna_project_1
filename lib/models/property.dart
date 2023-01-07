import 'dart:convert';

import 'package:flutter/foundation.dart';

class ServiceModel {
  String id;
  String? category;
  String? name;
  String? featuredImage;
  String? bannerImage;
  String? location;
  String? latitude;
  String? longitude;
  String? phoneNumber;
  String? about;
  int? rating;
  String? addedBy;
  DateTime? createdAt;
  ServiceModel({
    required this.id,
    this.category,
    this.name,
    this.featuredImage,
    this.bannerImage,
    this.location,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.about,
    this.rating,
    this.addedBy,
    this.createdAt,
  });

  ServiceModel copyWith({
    String? id,
    String? category,
    String? name,
    String? featuredImage,
    String? bannerImage,
    String? location,
    String? latitude,
    String? longitude,
    String? phoneNumber,
    String? about,
    int? rating,
    String? addedBy,
    DateTime? createdAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      featuredImage: featuredImage ?? this.featuredImage,
      bannerImage: bannerImage ?? this.bannerImage,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      about: about ?? this.about,
      rating: rating ?? this.rating,
      addedBy: addedBy ?? this.addedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'name': name,
      'featuredImage': featuredImage,
      'bannerImage': bannerImage,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'about': about,
      'rating': rating,
      'addedBy': addedBy,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
        id: map['id'] ?? '',
        category: map['category'],
        name: map['name'],
        featuredImage: map['featuredImage'],
        bannerImage: map['bannerImage'],
        location: map['location'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        phoneNumber: map['phoneNumber'],
        about: map['about'],
        rating: map['rating']?.toInt(),
        addedBy: map['addedBy'],
        createdAt: map['createdAt'] != null
            ? DateTime.fromMicrosecondsSinceEpoch(map['createdAt'])
            : DateTime.now());
  }

  String toJson() => json.encode(toMap());

  factory ServiceModel.fromJson(String source) =>
      ServiceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServiceModel(id: $id, category: $category, name: $name, featuredImage: $featuredImage, bannerImage: $bannerImage, location: $location, latitude: $latitude, longitude: $longitude, phoneNumber: $phoneNumber, about: $about, rating: $rating, addedBy: $addedBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceModel &&
        other.id == id &&
        other.category == category &&
        other.name == name &&
        other.featuredImage == featuredImage &&
        other.bannerImage == bannerImage &&
        other.location == location &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.phoneNumber == phoneNumber &&
        other.about == about &&
        other.rating == rating &&
        other.addedBy == addedBy &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        category.hashCode ^
        name.hashCode ^
        featuredImage.hashCode ^
        bannerImage.hashCode ^
        location.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        phoneNumber.hashCode ^
        about.hashCode ^
        rating.hashCode ^
        addedBy.hashCode ^
        createdAt.hashCode;
  }
}

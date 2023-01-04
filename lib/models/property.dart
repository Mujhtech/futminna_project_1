import 'dart:convert';

import 'package:flutter/foundation.dart';

class PropertyModel {
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
  List<String>? galleries;
  DateTime? createdAt;
  PropertyModel({
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
    this.galleries,
    this.createdAt,
  });

  PropertyModel copyWith({
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
    List<String>? galleries,
    DateTime? createdAt,
  }) {
    return PropertyModel(
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
      galleries: galleries ?? this.galleries,
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
      'galleries': galleries,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    return PropertyModel(
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
        galleries: List<String>.from(map['galleries']),
        createdAt: map['createdAt'] != null
            ? DateTime.fromMicrosecondsSinceEpoch(map['createdAt'])
            : DateTime.now());
  }

  String toJson() => json.encode(toMap());

  factory PropertyModel.fromJson(String source) =>
      PropertyModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PropertyModel(id: $id, category: $category, name: $name, featuredImage: $featuredImage, bannerImage: $bannerImage, location: $location, latitude: $latitude, longitude: $longitude, phoneNumber: $phoneNumber, about: $about, rating: $rating, addedBy: $addedBy, galleries: $galleries, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PropertyModel &&
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
        listEquals(other.galleries, galleries) &&
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
        galleries.hashCode ^
        createdAt.hashCode;
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PropertyModel {
  String id;
  String? occupation;
  String? name;
  String? featuredImage;
  String? bannerImage;
  String? location;
  String? latitude;
  String? longitude;
  String? website;
  String? userId;
  List<String>? galleries;
  DateTime? createdAt;
  PropertyModel({
    required this.id,
    this.occupation,
    this.name,
    this.featuredImage,
    this.bannerImage,
    this.location,
    this.latitude,
    this.longitude,
    this.website,
    this.userId,
    this.galleries,
    this.createdAt,
  });

  PropertyModel copyWith({
    String? id,
    String? occupation,
    String? name,
    String? featuredImage,
    String? bannerImage,
    String? location,
    String? latitude,
    String? longitude,
    String? website,
    String? userId,
    List<String>? galleries,
    DateTime? createdAt,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      occupation: occupation ?? this.occupation,
      name: name ?? this.name,
      featuredImage: featuredImage ?? this.featuredImage,
      bannerImage: bannerImage ?? this.bannerImage,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      website: website ?? this.website,
      userId: userId ?? this.userId,
      galleries: galleries ?? this.galleries,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'occupation': occupation,
      'name': name,
      'featuredImage': featuredImage,
      'bannerImage': bannerImage,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'website': website,
      'userId': userId,
      'galleries': galleries,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    return PropertyModel(
      id: map['id'] ?? '',
      occupation: map['occupation'],
      name: map['name'],
      featuredImage: map['featuredImage'],
      bannerImage: map['bannerImage'],
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      website: map['website'],
      userId: map['userId'],
      galleries: List<String>.from(map['galleries']),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PropertyModel.fromJson(String source) =>
      PropertyModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PropertyModel(id: $id, occupation: $occupation, name: $name, featuredImage: $featuredImage, bannerImage: $bannerImage, location: $location, latitude: $latitude, longitude: $longitude, website: $website, userId: $userId, galleries: $galleries, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PropertyModel &&
        other.id == id &&
        other.occupation == occupation &&
        other.name == name &&
        other.featuredImage == featuredImage &&
        other.bannerImage == bannerImage &&
        other.location == location &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.website == website &&
        other.userId == userId &&
        listEquals(other.galleries, galleries) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        occupation.hashCode ^
        name.hashCode ^
        featuredImage.hashCode ^
        bannerImage.hashCode ^
        location.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        website.hashCode ^
        userId.hashCode ^
        galleries.hashCode ^
        createdAt.hashCode;
  }
}

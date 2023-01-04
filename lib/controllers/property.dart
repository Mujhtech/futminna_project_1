import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:futminna_project_1/extension/firestore.dart';
import 'package:futminna_project_1/models/property.dart';
import 'package:futminna_project_1/providers/firebase.dart';
import 'package:futminna_project_1/repositories/custom_exception.dart';
import 'package:futminna_project_1/repositories/property.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final propertyController = ChangeNotifierProvider<PropertyController>((ref) {
  return PropertyController(ref)..retrieve();
});

class PropertyController extends ChangeNotifier {
  final Ref _ref;
  String? error;
  List<PropertyModel>? _properties;
  bool loading = false;

  List<PropertyModel>? get properties => _properties;

  PropertyController(this._ref) {
    retrieve();
  }

  PropertyModel filterTruckbyId(String id) {
    return _properties!.firstWhere((truck) => truck.id == id);
  }

  // Set<Marker> maps(customIcon, onClickMarker) {
  //   Set<Marker> trucks = {};

  //   if (_properties!.isNotEmpty) {
  //     Set<Marker> datas = _properties!
  //         .map((e) => Marker(
  //             onTap: () {
  //               onClickMarker(e);
  //             },
  //             markerId: MarkerId(e.title!),
  //             icon: customIcon,
  //             infoWindow: InfoWindow(title: e.title),
  //             position: LatLng(
  //                 double.parse(e.latitude!), double.parse(e.longitude!))))
  //         .toSet();

  //     trucks.addAll(datas);
  //   }

  //   return trucks;
  // }

  List<PropertyModel> filterByUser(String userId) {
    List<PropertyModel> filter = [];
    if (_properties != null && _properties!.isNotEmpty) {
      for (final data in _properties!) {
        if (data.addedBy == userId) {
          filter.add(data);
        }
      }
    }
    return filter;
  }

  Future<void> retrieve() async {
    try {
      loading = true;
      notifyListeners();
      final items = await _ref.read(propertyRepository).get();
      _properties = items;
      loading = false;
      notifyListeners();
    } on CustomException catch (e) {
      error = e.message;
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> create(
      String userId,
      String name,
      String occupation,
      String location,
      String phoneNumber,
      double latitude,
      double longitude,
      String bannerImage,
      String featuredImage,
      String description,
      List<String> galleries,
      {int rating = 1}) async {
    try {
      loading = true;
      notifyListeners();
      String id =
          _ref.read(firebaseFirestoreProvider).property().doc().id.toString();
      PropertyModel item = PropertyModel(
          id: id,
          name: name,
          category: occupation,
          about: description,
          location: location,
          bannerImage: bannerImage,
          featuredImage: featuredImage,
          phoneNumber: phoneNumber,
          latitude: '$latitude',
          longitude: '$longitude',
          rating: rating,
          addedBy: userId,
          galleries: galleries,
          createdAt: DateTime.now());
      await _ref.read(propertyRepository).create(id: id, item: item);
      loading = false;
      retrieve();
      notifyListeners();
      return true;
    } on CustomException catch (e) {
      error = e.message;
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(
      String id,
      String userId,
      String name,
      String occupation,
      String location,
      String phoneNumber,
      double latitude,
      double longitude,
      String bannerImage,
      String featuredImage,
      String description,
      List<String> galleries,
      {int rating = 1}) async {
    try {
      loading = true;
      notifyListeners();
      PropertyModel item = PropertyModel(
          id: id,
          name: name,
          category: occupation,
          about: description,
          location: location,
          bannerImage: bannerImage,
          featuredImage: featuredImage,
          phoneNumber: phoneNumber,
          latitude: '$latitude',
          longitude: '$longitude',
          addedBy: userId,
          rating: rating,
          galleries: galleries,
          createdAt: DateTime.now());
      await _ref.read(propertyRepository).create(id: id, item: item);
      loading = false;
      await retrieve();
      notifyListeners();
      return true;
    } on CustomException catch (e) {
      error = e.message;
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<List<String>> uploadFiles(List<File> images) async {
    loading = true;
    notifyListeners();
    var imageUrls = await Future.wait(images.map((image) => uploadFile(image)));
    //print(imageUrls);
    loading = false;
    notifyListeners();
    return imageUrls;
  }

  Future<String> uploadFile(File image) async {
    loading = true;
    notifyListeners();
    Reference ref = _ref
        .read(firebaseStorageProvider)
        .ref()
        .child("properties/${image.path}");
    UploadTask uploadTask = ref.putFile(image);
    final result = await uploadTask.then((res) async {
      return await res.ref.getDownloadURL();
    });
    loading = false;
    notifyListeners();
    return result;
  }

  Future<bool> removeImage(String url) async {
    try {
      loading = true;
      notifyListeners();
      Reference ref1 = _ref.read(firebaseStorageProvider).refFromURL(url);
      await ref1.delete();
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
  }
}

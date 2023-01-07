import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futminna_project_1/extension/firestore.dart';
import 'package:futminna_project_1/models/property.dart';
import 'package:futminna_project_1/providers/firebase.dart';
import 'package:futminna_project_1/repositories/custom_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BasePropertyRepository {
  Future<List<ServiceModel>> get();
  Future<void> create({required String id, required ServiceModel item});
  Future<void> remove({required String id});
  Future<void> update({required String id, required ServiceModel item});
}

final propertyRepository =
    Provider<PropertyRepository>((ref) => PropertyRepository(ref));

class PropertyRepository implements BasePropertyRepository {
  final Ref ref;
  const PropertyRepository(this.ref);

  @override
  Future<void> create({required String id, required ServiceModel item}) async {
    try {
      await ref
          .read(firebaseFirestoreProvider)
          .property()
          .doc(id)
          .set(item.toMap());
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<List<ServiceModel>> get() async {
    try {
      List<ServiceModel> trucks = [];
      final snap = await ref.read(firebaseFirestoreProvider).property().get();
      for (var doc in snap.docs) {
        ServiceModel truck =
            ServiceModel.fromMap(doc.data()! as Map<String, dynamic>);
        trucks.add(truck);
      }
      return trucks;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> remove({required String id}) async {
    try {
      await ref.read(firebaseFirestoreProvider).property().doc(id).delete();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> update({required String id, required ServiceModel item}) async {
    try {
      await ref
          .read(firebaseFirestoreProvider)
          .property()
          .doc(id)
          .update(item.toMap());
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}

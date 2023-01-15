import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:futminna_project_1/extension/firestore.dart';
import 'package:futminna_project_1/models/user.dart';
import 'package:futminna_project_1/providers/firebase.dart';
import 'package:futminna_project_1/repositories/auth.dart';
import 'package:futminna_project_1/repositories/custom_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Status { uninitialized, authenticated, authenticating, unauthenticated }

final authControllerProvider = ChangeNotifierProvider<AuthController>(
    (ref) => AuthController(ref)..appStarted());

class AuthController extends ChangeNotifier {
  final Ref _ref;
  User? _user;
  String? _error;
  UserModel? _fsUser;
  Status _status = Status.uninitialized;
  bool loading = false;

  String? get error => _error;
  Status? get status => _status;
  User? get fbUser => _user;
  UserModel? get user => _fsUser;

  StreamSubscription<User?>? _authStateChangesSubscription;

  AuthController(this._ref) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription = _ref
        .read(authRepositoryProvider)
        .authStateChanges
        .listen(_onAuthStateChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _authStateChangesSubscription?.cancel();
  }

  Future<void> appStarted() async {
    final user = _ref.read(authRepositoryProvider).getCurrentUser();
    if (user == null) {
      return;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      loading = true;
      notifyListeners();
      final res =
          await _ref.read(authRepositoryProvider).signIn(email, password);
      final user = await _ref
          .read(firebaseFirestoreProvider)
          .user()
          .doc(res!.user!.uid)
          .get();
      _fsUser = UserModel.fromMap(user.data()! as Map<String, dynamic>);
      _error = '';
      loading = false;
      notifyListeners();
      return true;
    } on CustomException catch (e) {
      _error = e.message;
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String fullname,
      String phone, String accountType) async {
    try {
      loading = true;
      notifyListeners();
      final res =
          await _ref.read(authRepositoryProvider).signUp(email, password);
      UserModel user = UserModel(
          loginType: 'user',
          email: email,
          password: password,
          fullName: fullname,
          phoneNumber: phone,
          profileImage: '',
          lastLoggedIn: DateTime.now(),
          uid: res!.user!.uid);
      await _ref
          .read(firebaseFirestoreProvider)
          .user()
          .doc(user.uid)
          .set(user.toMap());
      _fsUser = user;
      _error = '';
      loading = false;
      notifyListeners();
      return true;
    } on CustomException catch (e) {
      _error = e.message;
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> uploadProfileImage(File file) async {
    try {
      loading = true;
      notifyListeners();
      if (_fsUser!.profileImage!.isNotEmpty) {
        Reference ref1 = _ref
            .read(firebaseStorageProvider)
            .refFromURL(_fsUser!.profileImage!);
        await ref1.delete();
      }
      Reference ref = _ref
          .read(firebaseStorageProvider)
          .ref()
          .child("users/user_${_user!.uid}");
      UploadTask uploadTask = ref.putFile(file);
      final result = await uploadTask.then((res) async {
        return await res.ref.getDownloadURL();
      });
      await _ref
          .read(firebaseFirestoreProvider)
          .user()
          .doc(_user!.uid)
          .update({'profileImage': result});
      final user = await _ref
          .read(firebaseFirestoreProvider)
          .user()
          .doc(_user!.uid)
          .get();
      _fsUser = UserModel.fromMap(user.data()! as Map<String, dynamic>);
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeProfileImage() async {
    try {
      loading = true;
      notifyListeners();
      if (_fsUser!.profileImage!.isNotEmpty) {
        Reference ref1 = _ref
            .read(firebaseStorageProvider)
            .refFromURL(_fsUser!.profileImage!);
        await ref1.delete();
      }
      await _ref
          .read(firebaseFirestoreProvider)
          .user()
          .doc(_user!.uid)
          .update({'profile_picture': ''});
      final user = await _ref
          .read(firebaseFirestoreProvider)
          .user()
          .doc(_user!.uid)
          .get();
      _fsUser = UserModel.fromMap(user.data()! as Map<String, dynamic>);
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUser(
      String fullname, String email, String address, String number) async {
    try {
      loading = true;
      notifyListeners();
      await _ref.read(firebaseFirestoreProvider).user().doc(_user!.uid).update(
          {'fullName': fullname, 'email': email, 'phoneNumber': number});
      final user = await _ref
          .read(firebaseFirestoreProvider)
          .user()
          .doc(_user!.uid)
          .get();
      _fsUser = UserModel.fromMap(user.data()! as Map<String, dynamic>);
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateLoginType(String type) async {
    try {
      loading = true;
      notifyListeners();
      await _ref.read(firebaseFirestoreProvider).user().doc(_user!.uid).update({
        'loginType': type,
      });
      final user = await _ref
          .read(firebaseFirestoreProvider)
          .user()
          .doc(_user!.uid)
          .get();
      _fsUser = UserModel.fromMap(user.data()! as Map<String, dynamic>);
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _ref.read(authRepositoryProvider).signOut();
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _fsUser = null;
      _user = null;
      _status = Status.unauthenticated;
      notifyListeners();
    } else {
      _user = firebaseUser;
      final res = await _ref
          .read(firebaseFirestoreProvider)
          .user()
          .doc(_user!.uid)
          .get();
      _fsUser = UserModel.fromMap(res.data()! as Map<String, dynamic>);
      _status = Status.authenticated;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<bool> deactivateAccount() async {
    try {
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> checkIfPhoneIsTaken(String username) async {
    try {
      loading = true;
      notifyListeners();
      var collectionRef = await _ref
          .read(firebaseFirestoreProvider)
          .user()
          .where('phoneNumber', isEqualTo: username)
          .limit(1)
          .get();
      if (collectionRef.docs.isEmpty) {
        loading = false;
        notifyListeners();
        return true;
      } else {
        loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      loading = true;
      notifyListeners();
      final action = ActionCodeSettings(
          url: 'https://abubakradisa.page.link?passwordReset=$email',
          androidInstallApp: true,
          handleCodeInApp: true,
          androidPackageName: 'com.mujhtech.futminna_project_1',
          iOSBundleId: 'com.mujhtech.futminnaProject1');
      await _ref.read(authRepositoryProvider).forgotPassword(email, action);
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> resetPassword(String code, String newPassword) async {
    try {
      loading = true;
      notifyListeners();
      final userEmail =
          await _ref.read(authRepositoryProvider).verifyResetCode(code);
      await _ref.read(authRepositoryProvider).resetPassword(code, newPassword);

      var collectionRef = await _ref
          .read(firebaseFirestoreProvider)
          .user()
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();
      if (collectionRef.docs.isNotEmpty) {
        await _ref
            .read(firebaseFirestoreProvider)
            .user()
            .doc(collectionRef.docs[0].id)
            .update({'password': newPassword});
      }

      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      loading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:futminna_project_1/providers/firebase.dart';
import 'package:futminna_project_1/repositories/custom_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseAuthRepository {
  Stream<User?> get authStateChanges;
  Future<UserCredential?> signIn(String email, String password);
  Future<UserCredential?> signUp(String email, String password);
  Future<UserCredential?> socialSignIn(OAuthCredential credential);
  User? getCurrentUser();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> verifyResetCode(String code, String password);
}

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref));

class AuthRepository implements BaseAuthRepository {
  final Ref _ref;

  const AuthRepository(this._ref);

  @override
  Stream<User?> get authStateChanges =>
      _ref.read(firebaseAuthProvider).authStateChanges();

  @override
  User? getCurrentUser() {
    return _ref.read(firebaseAuthProvider).currentUser;
  }

  @override
  Future<UserCredential?> socialSignIn(OAuthCredential credential) async {
    try {
      return await _ref
          .read(firebaseAuthProvider)
          .signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<UserCredential?> signIn(email, password) async {
    try {
      final user = await _ref
          .read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _ref.read(firebaseAuthProvider).signOut();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<UserCredential?> signUp(email, password) async {
    try {
      final user = await _ref
          .read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> resetPassword(email) async {
    try {
      await _ref
          .read(firebaseAuthProvider)
          .sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> verifyResetCode(String code, String password) async {
    try {
      await _ref
          .read(firebaseAuthProvider)
          .confirmPasswordReset(code: code, newPassword: password);
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}

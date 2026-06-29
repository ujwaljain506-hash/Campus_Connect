import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
    final FirebaseAuth _auth = FirebaseAuth.instance;


Future<User?> signUp(String email, String password) async {
  try {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  } catch (e) {
    print('Signup error: $e');
    return null;
  }
}

Future<User?> signIn(String email, String password) async {
  try {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  } catch (e) {
    print('SignIn error: $e');
    return null;
  }
}
}
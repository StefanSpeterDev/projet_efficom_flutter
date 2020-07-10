import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseUser _firebaseUser;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository(
      {FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignin,
      FirebaseUser firebaseUser})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn(),
        _firebaseUser = firebaseUser ?? firebaseUser;

  // Login avec google
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  // Login just with email and password
  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Create an account
  // TODO:: Implement more fields than just email and password
  Future<FirebaseUser> signUp(
      {String email,
      String password,
      String firstname,
      String lastname}) async {
    print('Before');
   // FirebaseUser user = (
        await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    //) as FirebaseUser;

   // print("User $user");

    /*
    UserUpdateInfo info = new UserUpdateInfo();
    info.displayName = firstname;
    _firebaseUser.updateProfile(info);


    Firestore.instance.collection('users').document().setData({
      'firstname': firstname,
      'lastname': lastname,
      'email': user.email,
      'id': user.uid,
    });

    await user.reload();
    user = _firebaseAuth.currentUser() as FirebaseUser;
    print(user);

     */
  }

  // Logout
  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  // Check if user still sign in
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }
}

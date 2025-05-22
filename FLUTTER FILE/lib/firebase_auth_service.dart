import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 📌 Sign Up with Email & Password and Store User Data
  Future<User?> signUpWithEmailPassword(
      String name, String phone, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Store user details in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'phone': phone,
          'email': email,
          'profileImage': '',
          'avatar': '',
        });
      }
      return user;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  // 📌 Sign In with Email & Password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  // 📌 Fetch User Details from Firestore
  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  // 📌 Upload Profile Picture and Update Firestore
  Future<String?> uploadProfilePicture(String uid, File imageFile) async {
    try {
      Reference storageRef = _storage.ref().child('profile_pictures/$uid.jpg');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with the new profile picture URL
      await _firestore.collection('users').doc(uid).update({'profileImage': imageUrl});
      return imageUrl;
    } catch (e) {
      print("Error uploading profile picture: $e");
      return null;
    }
  }

  // 📌 Update Avatar Selection and Store in Firestore
  Future<void> updateAvatar(String uid, String avatarUrl) async {
    try {
      await _firestore.collection('users').doc(uid).update({'avatar': avatarUrl});
    } catch (e) {
      print("Error updating avatar: $e");
    }
  }

  // 📌 Sign Out User
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

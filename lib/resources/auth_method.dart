import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/resources/storage_method.dart';
import 'package:instagram_flutter/models/user.dart' as model; // 모델 import

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('user').doc(currentUser.uid).get();

    // usermodel에서 fromSnap 가져옴
    return model.User.fromSnap(snap);
  }

  // sign up user 회원가입
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occurred.";
    try {
      if (email.isNotEmpty ||
              password.isNotEmpty ||
              username.isNotEmpty ||
              bio.isNotEmpty
          // file != null
          ) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        // Firebase 저장소(Storage) 폴더명
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        // add user to our database (collectionPath) collectionPath에 웹주소 파라미터 입력
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          following: [],
          followers: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        //

        res = "success";
      }
    } on FirebaseAuthException catch (error) {
      // 이메일이 형식에 맞지 않을 때 에러메시지 반환
      if (error.code == 'invalid-email') {
        res = 'The E-mail is badly formatted.';
        // 비밀번호가 6자리 이내일 때 에러메시지 반환
      } else if (error.code == 'weak-password') {
        res = 'Password should be at least 6 characters.';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  // log in user 로그인
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (error) {
      // 유저가 존재하지 않을 경우 에러메시지 반환
      if (error.code == 'user-not-found') {
        res = 'The user does not exist.';
        // 비밀번호가 일치하지 않을 경우 에러메시지 반환
      } else if (error.code == 'wrong-password') {
        res = 'The password does not match.';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

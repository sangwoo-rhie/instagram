import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/resources/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl,
        });

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
}

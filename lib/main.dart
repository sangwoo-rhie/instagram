import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/screen/login_screen.dart';
import 'package:instagram_flutter/screen/signup_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyBCKzl1UbhZfjaJcrOT2vYo_ayr0VrX6kg",
      appId: "1:692453056588:web:a61c888ae3fd26aa5154e9",
      messagingSenderId: "692453056588",
      projectId: "instagram-b19c2",
      storageBucket: "instagram-b19c2.appspot.com",
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram',
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),

      // screen별 화면경로 구성
      home: StreamBuilder(
        stream: FirebaseAuth.instance
            .authStateChanges(), // .idTokenChanges() 또는 userChanges() 로그인/아웃시 사용

        builder: (context, snapshot) {
          // connection이 되었을 때
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error : ${snapshot.error}'),
              );
            }
          }
          // connection 중일때
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return const LoginScreen();
        },
      ), //SignupScreen() LoginScreen()
    );
  }
}

// // Import the functions you need from the SDKs you need
// import { initializeApp } from "firebase/app";
// // TODO: Add SDKs for Firebase products that you want to use
// // https://firebase.google.com/docs/web/setup#available-libraries

// // Your web app's Firebase configuration
// const firebaseConfig = {
//   apiKey: "AIzaSyBCKzl1UbhZfjaJcrOT2vYo_ayr0VrX6kg",
//   authDomain: "instagram-b19c2.firebaseapp.com",
//   projectId: "instagram-b19c2",
//   storageBucket: "instagram-b19c2.appspot.com",
//   messagingSenderId: "692453056588",
//   appId: "1:692453056588:web:a61c888ae3fd26aa5154e9"
// };

// // Initialize Firebase
// const app = initializeApp(firebaseConfig);

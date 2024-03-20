import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        // 우리가 필요로 하는 Budget 목록들 (utils/global_variables에서 가져옴)
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        // 모바일 앱 메인화면 아래 아이콘들
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: _page == 0 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: _page == 1 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle,
                  color: _page == 2 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite,
                  color: _page == 3 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _page == 4 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:instagram_flutter/providers/user_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:instagram_flutter/models/user.dart' as model;

// class MobileScreenLayout extends StatefulWidget {
//   const MobileScreenLayout({Key? key}) : super(key: key);

//   @override
//   State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
// }

// class _MobileScreenLayoutState extends State<MobileScreenLayout> {
//   @override
//   Widget build(BuildContext context) {
//     model.User? user = Provider.of<UserProvider>(context).getUser;
//     return Scaffold(
//         body: Center(
//       child: Text(user!.username),
//     ));
//   }
// }

//

// String username = "";

// @override
// void initState() {
//   super.initState();
//   getUsername();
// }

// void getUsername() async {
//   DocumentSnapshot snap = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .get();

//   setState(() {
//     username = (snap.data() as Map<String, dynamic>)['username'];
//   });
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//       body: Center(
//     child: Text('${username}'),
//   ));
// }

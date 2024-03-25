import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screen/add_post_screen.dart';
import 'package:instagram_flutter/screen/feed_screen.dart';
import 'package:instagram_flutter/screen/profile_screen.dart';
import 'package:instagram_flutter/screen/search.screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(), // Text('feed'),
  const SearchScreen(), // Text('search'),
  const AddPostScreen(), // Text('add post'),
  const Text('notification'), // Text('notification'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ) // Text('profile'),
];

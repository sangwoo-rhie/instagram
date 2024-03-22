import 'package:flutter/material.dart';
import 'package:instagram_flutter/screen/add_post_screen.dart';
import 'package:instagram_flutter/screen/feed_screen.dart';
import 'package:instagram_flutter/screen/profile_screen.dart';
import 'package:instagram_flutter/screen/search.screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(), // Text('feed'),
  SearchScreen(), // Text('search'),
  AddPostScreen(), // Text('add post'),
  // Text('notification'),
  ProfileScreen() // Text('profile'),
];

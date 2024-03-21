import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({ Key?key }) : super(key:key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

// Comment 버튼을 누르고 들어왔을 떄 Comment 창
class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor, 
        title: const Text("Comments"),
        centerTitle: false,),
        body: CommentCard(), // Comment Widget에서 가져옴
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom
              ),
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: 
                    NetworkImage('https://images.unsplash.com/photo-1682687219356-e820ca126c92?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                    radius: 18,
                  ),
                  Expanded(
                    child: Padding(padding: const EdgeInsets.only(left: 16, right: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                        hintText: "Comment as username",
                        border: InputBorder.none,
                    ),
                  ),),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: const Text('Post', style: TextStyle(color: blueColor)),
                      ),
                  )
                ],),
        ),),
    )
  }
}
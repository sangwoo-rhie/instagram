import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:image_picker/image_picker.dart";
import "package:instagram_flutter/models/user.dart";
import "package:instagram_flutter/providers/user_provider.dart";
import "package:instagram_flutter/resources/firestore_methods.dart";
import "package:instagram_flutter/utils/colors.dart";
import "package:instagram_flutter/utils/utils.dart";
import "package:provider/provider.dart";

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false; // 로딩상태

  void postImage(String uid, String username, String profileImage) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profileImage);

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        // Post업로드 성공한 경우 snackBar 보여줌
        showSnackBar("Posted!", context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (error) {
      showSnackBar(error.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a Post"),
            children: [
              // 포스트 업로드 시 카메라 선택
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  ); // utils.dart에서 가져옴

                  setState(() {
                    _file = file;
                  });
                },
              ),
              // 포스트 업로드 시 갤러리 선택
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  ); // utils.dart에서 가져옴

                  setState(() {
                    _file = file;
                  });
                },
              ),
              // 취소
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        // file이 null일때, 즉 선택되지 않았을 때
        ? Center(
            child: IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () => _selectImage(context),
          ))
        // file이 선택되었을 때
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                // Post 버튼
                TextButton(
                    onPressed: () =>
                        postImage(user!.uid, user.username, user.photoUrl),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            body: Column(
              children: [
                // 로딩상태가 true일 경우 LinearProgressIndicator / false일경우(로딩끝난경우) Container
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(), // 로딩창과의 간격
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      // 유저가 선택한 이미지가 화면에 표시됨
                      backgroundImage: NetworkImage(
                        user!.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: MemoryImage(_file!),
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                          )),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                )
              ],
            ),
          );
  }
}

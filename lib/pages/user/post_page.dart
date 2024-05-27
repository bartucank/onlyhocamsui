import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:onlyhocamsui/models/PostDTO.dart';
import 'package:onlyhocamsui/models/PostDTOListResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:we_slide/we_slide.dart';

import '../../models/CategoryDTO.dart';
import '../../models/CategoryDTOListResponse.dart';
import '../../service/ApiService.dart';

import '../../service/constants.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage>
    with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CategoryDTO> categories = [];
  CategoryDTO _selectedValue = CategoryDTO();
  List<PostDTO> postDTOList = [];
  List<PostDTO> lastList = [];

  void fetchCategories() async {
    try {
      CategoryDTOListResponse response = await apiService.getCategories();
      print(response);
      setState(() {
        categories.clear();
        categories.addAll(response.data);
        _selectedValue = categories.first;
      });
    } catch (e) {
    }

    final jwtToken = await apiService.getUserId();
    if(jwtToken != "NOT_FOUND"){
      print(jwtToken);
      currentUserId = int.tryParse(jwtToken!) ?? -1;
    }
    final role = await apiService.getRole();
    if(role != "NOT_FOUND"){
      print(role);
      currentUserRole = role!;
    }
    fetchFirstPosts();

  }

  Future refresh() async {
    setState(() {
      lastList.clear();
      postDTOList.clear();
      keywordcontroller.clear();
    limit = 20;
    offset = -20;
      lastrecievedpost = 0;
    });

    fetchFirstPosts();
  }
  @override
  void dispose() {
    super.dispose();
  }
  void fetchFirstPosts() async {
    if(isLoading){
      return;
    }
    setState(() {
      isLoading = true;
    });
    setState(() {
      offset = offset+limit;
    });
    try {
      lastList.clear();
      PostDTOListResponse response =
      await apiService.getPosts(limit,offset,_selectedValue.id!,keywordcontroller.text);
      setState(() {
        postDTOList.addAll(response.data);
        lastList.addAll(response.data);
        lastrecievedpost = response.data.length;
      });
    } catch (e) {
      print("Error! $e");
    }
    setState(() {
      isLoading = false;
    });
  }
  void fetchmoreposts() async {
    if(isLoading){
      return;
    }
    setState(() {
      isLoading = true;
    });
    setState(() {
      offset = offset+limit;
    });
    try {
      lastList.clear();
      PostDTOListResponse response =
      await apiService.getPosts(limit,offset,_selectedValue.id!,keywordcontroller.text);
      setState(() {
        postDTOList.addAll(response.data);
        lastList.addAll(response.data);
        lastrecievedpost = response.data.length;
      });
    } catch (e) {
      print("Error! $e");
    }
    setState(() {
      isLoading = false;
    });
  }
  void getfilteredposts() async {
    setState(() {
      offset = offset+limit;
    });
    try {
      print("okkkkk");
      PostDTOListResponse response =
      await apiService.getPosts(limit,offset,_selectedValue.id!,keywordcontroller.text);
      setState(() {
        postDTOList.addAll(response.data);
        lastList.addAll(response.data);
        lastrecievedpost = response.data.length;
      });
    } catch (e) {
      print("Error! $e");
    }
    setState(() {
      isLoading = false;
    });
  }

  void filter() async {
    setState(() {
      offset = -20;
      limit = 20;
    });
    try {
      lastList.clear();
      postDTOList.clear();
      lastrecievedpost=-1;
    } catch (e) {
      print("Error! $e");
    }
    print("hereee"+_selectedValue.id!.toString());
    setState(() {
      getfilteredposts();
    });

  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
    listcontroller.addListener(() {
      if (listcontroller.position.maxScrollExtent == listcontroller.offset) {
        fetchmoreposts();
      }
    });

  }
  WeSlideController weSlideController = WeSlideController();
  int page = -1;
  int limit = 20;
  int offset = -20;
  int lastrecievedpost = -1;
  bool isLoading = false;
  final double _panelMinSize = 70.0;
  int currentUserId = -1;
  String currentUserRole = "USER";
  TextEditingController keywordcontroller = TextEditingController();

  final listcontroller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Constants.mainBackgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.mainBlueColor,
        title: Text(
          'Posts',
          style: TextStyle(color: Constants.whiteColor),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Constants.whiteColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:WeSlide(
        controller: weSlideController,
        panelMinSize: _panelMinSize,
        blur: false,
        panelMaxSize: MediaQuery.of(context).size.height / 2,
        overlayColor: Constants.mainDarkColor,
        blurColor: Constants.mainDarkColor,
        blurSigma: 2,
        backgroundColor: Colors.white,
        overlayOpacity: 0.7,
        overlay: true,
        panel: Container(
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: DropdownButtonFormField<CategoryDTO>(
                    value: _selectedValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Search by Category",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: Constants.mainDarkColor,
                      ),
                      filled: true,
                      fillColor: Color(0x00ffffff),
                      isDense: false,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      prefixIcon: Icon(Icons.alternate_email, color: Constants.mainDarkColor, size: 18),
                      border: OutlineInputBorder(  // Add this line to define a border
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(color: Constants.mainDarkColor, width: 1),
                      ),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem<CategoryDTO>(
                        value: category,
                        child: Row(
                          children: [
                            SizedBox(width: 8),
                            Text(category.name!),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: TextField(
                    controller: keywordcontroller,
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Constants.mainDarkColor,
                    ),
                    decoration: InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                            color: Constants.mainDarkColor, width: 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                            color: Constants.mainDarkColor, width: 1),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide(
                            color: Constants.mainDarkColor, width: 1),
                      ),
                      labelText: "Keyword",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: Constants.mainDarkColor,
                      ),
                      filled: true,
                      fillColor: Color(0x00ffffff),
                      isDense: false,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      prefixIcon: Icon(Icons.text_fields,
                          color: Constants.mainDarkColor, size: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            filter();

                            FocusScope.of(context).unfocus();
                            weSlideController.hide();
                          },
                          color: Constants.mainBlueColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: Color(0xff808080), width: 1),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "Apply Filter",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          textColor: Colors.white,
                          height: 45,
                        ),
                      ),

                    ],
                  ),
                )
              ],
            )),
        footer: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.search), label: 'Filter'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add), label: 'Share Post'),
          ],
          elevation: 0,
          backgroundColor: Constants.mainBlueColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          //Colors.grey,
          onTap: (index) {
            if (index == 0) {
              weSlideController.show();
            }
            if(index == 1){

            }
          },
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
          child: postDTOList.isEmpty
              ? Text("")
              : RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
              controller: listcontroller,
              itemCount: postDTOList.length + 1,
              itemBuilder: (context2, index) {
                if (index < postDTOList.length) {
                  PostDTO currentbook = postDTOList[index];
                  int likecount = 0;
                  int dislikecount = 0;
                  bool isLiked = false;
                  bool isDisliked = false;
                  bool isOwnerOrAdmin = false;
                  if(currentUserRole == "ADMIN"){
                    isOwnerOrAdmin = true;
                  }else if(currentbook.user!.id! == currentUserId){
                    isOwnerOrAdmin = true;
                  }
                  currentbook.actions?.forEach((element) {
                    if(element.type == "LIKE"){
                      likecount++;
                    }else{
                      dislikecount++;
                    }
                    if(element.user!.id == currentUserId){
                      isLiked = element.type == "LIKE";
                      isDisliked = !isLiked;
                    }
                  });
                  return PostWidget(post:currentbook,likec:likecount,dislikec:dislikecount,isliked:isLiked, isdisliked:isDisliked,candelete:isOwnerOrAdmin);
                } else {
                  if (!lastList.isEmpty && lastrecievedpost==20) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 64),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }
              },
            ),
          ),
        ),
      )
    );
  }
}
class CategoryButton extends StatelessWidget {
  final CategoryDTO category;

  const CategoryButton({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        print("Category: ${category.name}");
      },
      child: Text(category.name!),
    );
  }
}

class PostWidget extends StatefulWidget {
  final PostDTO post;
  final int likec;
  final int dislikec;
  final bool isliked;
  final bool isdisliked;
  final bool candelete;

  PostWidget({
    required this.post,
    required this.likec,
    required this.dislikec,
    required this.isliked,
    required this.isdisliked,
    required this.candelete
  });

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isCommentsVisible = false;
  void _showAddCommentDialog() {
    final TextEditingController _commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  focusColor: Constants.mainBlueColor,
                  fillColor: Constants.mainBlueColor,
                  hoverColor: Constants.mainBlueColor,

                  hintText: 'Enter your comment',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String result = await apiService.addComment(widget.post.id , _commentController.text);
                if (result=='200'){
                showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(
                message: "Wrong username/password!",
                textAlign: TextAlign.left,
                ),
                );
                }
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 10, color: Colors.black),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 7.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.post.user!.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
                      SizedBox(height: 5.0),
                      Text(widget.post.formattedDate!, style: TextStyle(fontSize: 11.0)),
                    ],
                  ),
                  Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (String result) async {
                      if (result == 'delete') {
                        String result=await apiService.deletePost(widget.post.id);
                        if(result==1) {
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.error(
                              message: "Wrong username/password!",
                              textAlign: TextAlign.left,
                            ),
                          );
                        }
                      }else if(result == 'addcom'){

                        _showAddCommentDialog();

                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      if(widget.candelete)
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'addcom',
                        child: Text('Add Comment'),
                      ),
                    ],
                    icon: Icon(Icons.more_vert),
                  ),
                ],
              ),
              Divider(height: 10),
              Align(
                alignment: Alignment.topLeft,
                child: Text(widget.post.content!, style: TextStyle(fontSize: 15.0)),
              ),
              if (widget.post.documents != null && widget.post.documents!.isNotEmpty)
                SizedBox(
                  height: 150,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.post.documents!.take(3).map((doc) {
                        Uint8List? data = doc.data;
                        return data != null
                            ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InstaImageViewer(
                            child: Image.memory(data),
                          ),
                        )
                            : SizedBox.shrink();
                      }).toList(),
                    ),
                  ),
                ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('${widget.likec} like/s', style: TextStyle(fontSize: 10.0)),
                      Text('  •  '),
                      Text('${widget.dislikec} dislike/s', style: TextStyle(fontSize: 10.0)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('${widget.post.comments!.length.toString()} comments  •  ', style: TextStyle(fontSize: 10.0)),
                    ],
                  ),
                ],
              ),
              Divider(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      //todo: like
                      print("clicked");
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.thumbsUp, size: 20.0, color: widget.isliked ? Colors.green : Colors.black),
                        SizedBox(width: 5.0),
                        Text('Like', style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //todo: dislike
                      print("clicked");
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.thumbsDown, size: 20.0, color: widget.isdisliked ? Colors.red : Colors.black),
                        SizedBox(width: 5.0),
                        Text('Dislike', style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCommentsVisible = !isCommentsVisible;
                      });
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.comment, size: 20.0),
                        SizedBox(width: 5.0),
                        Text('Comments', style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: isCommentsVisible && widget.post.comments!.isNotEmpty,
                child: Column(
                  children: widget.post.comments!.map((comment) {
                    return ListTile(
                      title: Text(comment.user!.name!),
                      subtitle: Text(comment.content!),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:onlyhocamsui/models/NoteDTO.dart';
import 'package:onlyhocamsui/models/NoteDTOListResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:we_slide/we_slide.dart';

import '../../models/CategoryDTO.dart';
import '../../models/CategoryDTOListResponse.dart';
import '../../models/NoteDTO.dart';
import '../../service/ApiService.dart';

import '../../service/constants.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';

import 'NoteDetailSreen.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage>
    with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<NoteDTO> noteDTOList = [];
  List<NoteDTO> lastList = [];

  bool _switchValue = false;
  void fetchCurrentUser() async {
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
      noteDTOList.clear();
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
      NoteDTOListResponse response =
      await apiService.getNotes(limit,offset,keywordcontroller.text,_switchValue);
      setState(() {
        noteDTOList.addAll(response.data);
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
      NoteDTOListResponse response =
      await apiService.getNotes(limit,offset,keywordcontroller.text,_switchValue);
      setState(() {
        noteDTOList.addAll(response.data);
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
      NoteDTOListResponse response =
      await apiService.getNotes(limit,offset,keywordcontroller.text,_switchValue);
      setState(() {
        noteDTOList.addAll(response.data);
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
      noteDTOList.clear();
      lastrecievedpost=-1;
    } catch (e) {
      print("Error! $e");
    }
    setState(() {
      getfilteredposts();
    });

  }

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
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
  TextEditingController notenamecontroller = TextEditingController();

  final listcontroller = ScrollController();


  FilePickerResult? pickedFile;

  void showaddntepopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add File"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: notenamecontroller,
                decoration: InputDecoration(hintText: "Enter Note Title"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  pickedFile = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf','PDF'],
                  );
                  if (pickedFile != null) {
                    print("File selected: ${pickedFile?.files.single.name}");
                  }
                },
                child: Text("Select PDF"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Object a = saveMaterial();
                  if(a != -1){
                    notenamecontroller.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Send to approvement")
            ),
          ],
        );
      },
    );
  }


  Future<int> saveMaterial() async {
    if(notenamecontroller.text.isEmpty){
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message:
          "Note name cannot be empty.",
          textAlign: TextAlign.left,
        ),
      );
      return -1;
    }
    setState(() {
      isLoading = true;
    });

    if (pickedFile != null) {
      String filePath = pickedFile!.files.single.path!;

      try {
        int docId = await apiService.uploadDocument(filePath);

        if (docId != "-1") {

          //todo: add note service call with docId.
          String result = "";//here apiservice should return "ok" if http status is 200. else return "-1"
          if(result == "ok"){
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.success(
                message: "Note sent to approval process.",
                textAlign: TextAlign.left,
              ),
            );
          }else{
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.error(
                message: "Unexpected error. Please contact system administrator.",
                textAlign: TextAlign.left,
              ),
            );
          }

        } else {

          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Please provide valid file.",
              textAlign: TextAlign.left,
            ),
          );
        }
      } catch (e) {
        print(e);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "Unexpected error. Please contact system administrator.",
            textAlign: TextAlign.left,
          ),
        );
      }
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "No file selected.",
          textAlign: TextAlign.left,
        ),
      );
    }

    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Constants.mainBackgroundColor,
        appBar: AppBar(
          backgroundColor: Constants.mainBlueColor,
          title: Text(
            'Notes',
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
                  if(currentUserRole == "ADMIN")
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child:  Row(
                      children: [
                        Expanded(
                          child: Text("Unapproved Notes",style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Constants.mainDarkColor,
                          ),),
                        ),
                        CupertinoCheckbox(
                          activeColor: Constants.mainBlueColor,
                          focusColor: Constants.mainBlueColor,
                          value: _switchValue,
                          onChanged: (value) {
                            setState(() {
                              _switchValue = value!;
                            });
                          },
                        )
                      ],
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
                showaddntepopup(context);
              }
            },
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
            child: noteDTOList.isEmpty
                ? Text("")
                : RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                controller: listcontroller,
                itemCount: noteDTOList.length + 1,
                itemBuilder: (context2, index) {
                  if (index < noteDTOList.length) {
                    NoteDTO currentbook = noteDTOList[index];
                    int likecount = 0;
                    int dislikecount = 0;
                    bool isLiked = false;
                    bool isDisliked = false;
                    bool isOwner = false;
                    bool isAdmin = false;
                    if(currentbook.user!.id! == currentUserId){
                      isOwner = true;
                    }
                    if(currentUserRole == "ADMIN"){
                      isAdmin = true;
                    }

                      return GestureDetector(
                      onTap: () async {
                        print("clicked");
                        NoteDTO detailedNote = await apiService.getnotebyid(currentbook.id!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailScreen(note: detailedNote,isAdmin:isAdmin,isOwner:isOwner),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide()),
                        ),
                        child: ListTile(
                          title: NoteCard(note: currentbook,),
                        ),
                      ),
                    );
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
class NoteCard extends StatelessWidget {
  final NoteDTO note;

  NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
      title: Text(note.title!),
      subtitle: Text("By "+note.user!.name!),
      // leading: CircleAvatar(
      //   radius: 15,
      //   backgroundImage: AssetImage('assets/images/default.png'),
      // ),
    );

  }
}
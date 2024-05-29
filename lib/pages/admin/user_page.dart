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
import 'package:onlyhocamsui/models/UserDTO.dart';
import 'package:onlyhocamsui/models/UserDTOListResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:we_slide/we_slide.dart';

import '../../models/CategoryDTO.dart';
import '../../models/CategoryDTOListResponse.dart';
import '../../models/UserDTO.dart';
import '../../service/ApiService.dart';

import '../../service/constants.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';


class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<UserDTO> UserDTOList = [];
  List<UserDTO> lastList = [];

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
    fetchUsers();

  }


  @override
  void dispose() {
    super.dispose();
  }
  void fetchUsers() async {
    UserDTOListResponse response =
    await apiService.getUsers();
    setState(() {
      UserDTOList = response.data;
    });
  }


  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Constants.mainBackgroundColor,
        appBar: AppBar(
          backgroundColor: Constants.mainBlueColor,
          title: Text(
            'Users',
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
                ],
              )),
          footer: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Coming Soon'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add), label: 'Coming Soon'),
            ],
            elevation: 0,
            backgroundColor: Constants.mainBlueColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            //Colors.grey,
            onTap: (index) {
              if (index == 0) {
              }
              if(index == 1){
              }
            },
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
            child: UserDTOList.isEmpty
                ? Text("")
                : ListView.builder(
                  controller: listcontroller,
                  itemCount: UserDTOList.length + 1,
                  itemBuilder: (context2, index) {
                    if (index < UserDTOList.length) {
                      UserDTO currentbook = UserDTOList[index];
                        return GestureDetector(
                        onTap: () async {
                          fetchUsers();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide()),
                          ),
                          child: ListTile(
                            title: UserCard(note: currentbook,),
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
class UserCard extends StatelessWidget {
  final UserDTO note;

  UserCard({required this.note});

  @override
  Widget build(BuildContext context) {

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 16),
      title: Text(note.name!),
      subtitle: Text(note.username!),
      // leading: CircleAvatar(
      //   radius: 15,
      //   backgroundImage: AssetImage('assets/images/default.png'),
      // ),
    );

  }
}
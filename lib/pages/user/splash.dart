import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onlyhocamsui/pages/Onboarding/LoginScreen.dart';
import 'package:onlyhocamsui/pages/admin/category_page.dart';
import 'package:onlyhocamsui/service/constants.dart';
import '../../service/ApiService.dart';
import '../admin/user_page.dart';
import 'note_page.dart';
import 'post_page.dart';

class SplashPage extends StatelessWidget {

  final ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await apiService.logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        child: Icon(Icons.logout,color:Colors.white),
        backgroundColor: Constants.mainBlueColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostPage()),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          Icons.share,
                        size: MediaQuery.of(context).size.width/2  -50,
                        color: Constants.mainBlueColor,
                      ),
                      Text("Posts",style: TextStyle(color: Constants.mainDarkColor,fontSize: 25),)
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotePage()),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          Icons.note_add_outlined,
                        size: MediaQuery.of(context).size.width/2  -50,
                        color: Constants.mainBlueColor,
                      ),
                      Text("Notes",style: TextStyle(color: Constants.mainDarkColor,fontSize: 25),)
                    ],
                  ),
                ),
            ],),
            FutureBuilder<String?>(
              future: apiService.getRole(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    return Text('');
                  } else {
                    final role = snapshot.data;
                    return role == "ADMIN"
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserPage()),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.peoplePulling,
                                size: MediaQuery.of(context).size.width/2  -50,
                                color: Constants.mainBlueColor,
                              ),
                              Text("Users",style: TextStyle(color: Constants.mainDarkColor,fontSize: 25),)
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CategoryPage()),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category,
                                size: MediaQuery.of(context).size.width/2  -50,
                                color: Constants.mainBlueColor,
                              ),
                              Text("Categories",style: TextStyle(color: Constants.mainDarkColor,fontSize: 25),)
                            ],
                          ),
                        ),

                      ],)
                        :
                    role == "USER"?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [


                      ],):SizedBox();
                  }
                }
              },
            ),

          ],
        ),
      ),
    );
  }
}

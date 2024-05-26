import 'package:flutter/material.dart';
import 'package:onlyhocamsui/pages/Onboarding/LoginScreen.dart';
import 'package:onlyhocamsui/service/constants.dart';
import '../../service/ApiService.dart';
import 'note_page.dart';
import 'post_page.dart';

class SplashPage extends StatelessWidget {

  final ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: ()async{
                apiService.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
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
          ],
        ),
      ),
    );
  }
}

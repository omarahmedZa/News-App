import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_application/shared/componants/app_bar.dart';
import 'package:news_application/shared/componants/font_style.dart';

int pageIndex = 2;

class AddPostScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        myTitle: myTextStyle(
            text: 'Add Post'
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200.0,
                  ),
                  Text(
                    'Post Title',
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Post Description',
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Container(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: ()
                      {

                      },
                      child: Text(
                          'Add Post'
                      ),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
                Icons.home
            ),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.search
            ),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.person
            ),
            label: 'profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.heart_broken
            ),
            label: 'favorites',
          ),
        ],
      ),
    );
  }

}
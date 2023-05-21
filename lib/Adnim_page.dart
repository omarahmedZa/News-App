import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_application/add_post_screen.dart';

int pageIndex = 2;

class AdminPage extends StatefulWidget{
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Admin Page',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0
        ),
        child: Center(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 80,
                      child: Icon(
                        Icons.person,
                        size: 120,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top:  80.0
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: ()
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPostScreen()
                              ),

                          );
                        },
                        child: Text(
                          'Add Post'
                        ),
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: ()
                        {

                        },
                        child: Text(
                            'Edit Post'
                        ),
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: ()
                        {

                        },
                        child: Text(
                            'Delete Post'
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
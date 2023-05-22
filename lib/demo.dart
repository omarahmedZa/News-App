import 'dart:js_util';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'post_model.dart';
import 'package:news_application/PostDetailsPage.dart';

class demo extends StatefulWidget {
  const demo({Key? key}) : super(key: key);

  @override
  _demoState createState() => _demoState();
}

class _demoState extends State<demo> {
  static List<PostModel> posts = [
    PostModel("the first post", "about the weather"),
    PostModel("title", "description")
  ];
  static List<PostModel> dis_posts = List.from(posts);

  void updatelist(String value) {
    setState(() {
      dis_posts = posts
          .where((element) =>
          element.title!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void showPost(PostModel post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailsPage(post: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 24.0,
        title: const Text(
          'News Page',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 24.0),
            child: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          right: 24.0,
          left: 24.0,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                ),
                suffixIcon: Image(
                  image: AssetImage('icons/Icon.png'),
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => updatelist(value),
            ),
            Container(
              color: Colors.blueGrey, // set the background color of the container
              child: SizedBox(
                height: 20.0,
              ),
            ),
            Expanded(
              child: dis_posts.length == 0
                  ? Center(
                child: Text(
                  "No result found",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: dis_posts.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = dis_posts[index];
                  return GestureDetector(
                    onTap: () => showPost(post),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      title: Text(
                        post.title!,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${post.description!}',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
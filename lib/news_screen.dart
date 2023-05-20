import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
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
            padding: EdgeInsets.only(
              right: 24.0
            ),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
               decoration: const InputDecoration(
                 labelText: 'Search',
                 prefixIcon: Icon(
                   Icons.search,
                 ),
                 suffixIcon: Image(
                     image: AssetImage(
                       'icons/Icon.png'
                     ),
                 ),
                 border: OutlineInputBorder(),
               ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Trending',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 20.0,
                          child: TextButton(
                            onPressed: ()
                            {

                            },
                            style: const ButtonStyle(
                                padding: MaterialStatePropertyAll<EdgeInsetsDirectional>(
                                  EdgeInsetsDirectional.all(0.0),
                                )
                            ),
                            child: const Text(
                                'See all'
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    const Image(
                        image: AssetImage(
                          'images/image 1.png'
                        ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Europe',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Russian warship: Moskva sinks in Black Sea',
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                'images/Ellipse.png'
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: 4.0,
                              end: 12.0,
                              top: 1.0
                            ),
                            child: Text(
                              'BBC News',
                              style: TextStyle(
                                fontSize: 19.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              top: 5.0,
                              bottom: 1.0,
                            ),
                            child: Icon(
                              CupertinoIcons.clock,
                              size: 17.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                              top: 6.0,
                              start: 4.0
                            ),
                            child: Text(
                              '4h ago',
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Latest',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 20.0,
                          child: TextButton(
                            onPressed: ()
                            {

                            },
                            style: const ButtonStyle(
                              padding: MaterialStatePropertyAll<EdgeInsetsDirectional>(
                                EdgeInsetsDirectional.all(0.0),
                              )
                            ),
                            child: const Text(
                                'See all'
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                height: 19.0,
                width: double.infinity,

                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => NewsType(),
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10.0,
                    ),
                    itemCount: 20,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => NewsItem(),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10.0,
                ),
                itemCount: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget NewsItem() => Row(
    children: [
      Container(
        alignment: AlignmentDirectional.centerStart,
        height: 96,
        width: 96,
        child: Column(
          children: const [
            Image(
              image: AssetImage(
                  'images/News Images.png'
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        width: 4.0,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                  bottom: 10.0
              ),
              child: Text(
                'Europe',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            Text(
              'Ukraine\'s President Zelensky to BBC: Bvalueslood money being paid',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                        'images/Ellipse.png'
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: 4.0,
                      end: 12.0,
                      top: 1.0
                  ),
                  child: Text(
                    'BBC News',
                    style: TextStyle(
                      fontSize: 19.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    top: 5.0,
                    bottom: 1.0,
                  ),
                  child: Icon(
                    CupertinoIcons.clock,
                    size: 17.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      top: 6.0,
                      start: 4.0
                  ),
                  child: Text(
                    '4h ago',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
  Widget NewsType() => SizedBox(

    child: TextButton(
      onPressed: ()
      {

      },
      style: const ButtonStyle(
          padding: MaterialStatePropertyAll<EdgeInsetsDirectional>(
            EdgeInsetsDirectional.all(0.0),
          )
      ),
      child: const Text(
        'sport',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
  );
}
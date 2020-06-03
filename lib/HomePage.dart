import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'PhotoUpload.dart';
import 'Posts.dart';
//import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  HomePage({
    this.auth,
    this.onSignedOut,
});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //create Posts class and list to store posts details
  List<Posts> postsList = [];

  //backened
  //reteriving data using keys
  @override
  void initState() {
    super.initState();

    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Posts");

    postsRef.once().then((DataSnapshot snap){
      var KEYS=snap.value.keys;
      var DATA=snap.value;

      postsList.clear();

      for(var individualKey in KEYS){
        Posts posts = new Posts(
          DATA[individualKey]['image'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
      );
        postsList.add(posts);
      }
      setState(() {
        print('Length: $postsList.length');
      });
    });
  }

  //logout a user by calling signOut function from authentication page
  void _logoutUser() async{
      await widget.auth.signOut();
      widget.onSignedOut();
  }

  //design
  //called _logoutUser function to logout
  //go to photoUploadPage to upload a photo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Blogger',
          style: TextStyle(
            fontFamily: 'Pacifico',
          ),
        ),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.person),
                  tooltip: 'Air it',
                  onPressed: _logoutUser,
              ),
        ],
      ),
      body: Container(
        child: postsList.length==0 ? Text('NO Blog Posts available') :ListView.builder(
          itemCount: postsList.length,
            itemBuilder: (_,index){
              return postsUI(postsList[index].image,postsList[index].description,postsList[index].date,postsList[index].time);
            }
        ),
      ),
//      bottomNavigationBar: BottomAppBar(
//         color: Colors.pink,
//
//        child: Container(
//          margin: const EdgeInsets.only(left:70.0 , right: 70.0),
//
//         child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          mainAxisSize: MainAxisSize.max,
//
//          children: <Widget>[
//            IconButton(
//              icon: Icon(Icons.person_outline),
//              iconSize: 50,
//              color: Colors.white,
//
//              onPressed: _logoutUser,
//            ),
//            IconButton(
//                icon: Icon(Icons.add_a_photo),
//                iconSize: 50,
//                color: Colors.white,
//
//                onPressed: (){
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context){
//                        return PhotoUploadPage();
//                      },
//                      ),
//                  );
//                },
//            ),
//          ],
//        ),
//        ),
//      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return PhotoUploadPage();
                      },
                      ),
                  );
                },
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  //design of posts UI
  Widget postsUI (String image,String description, String date,String time){
    return Card (
      elevation: 10.0,

      margin: EdgeInsets.all(15.0),

      child: Container(
        padding: EdgeInsets.all(14.0),

        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: <Widget>[
                Text (
                  date,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
                Text (
                  time,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 10.0,),
            
            Image.network(image,fit:BoxFit.cover),

            SizedBox (height: 10.0,),

            Text (
              description,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
    );
  }
}

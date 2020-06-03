import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'HomePage.dart';

class PhotoUploadPage extends StatefulWidget {
  @override
  _PhotoUploadPageState createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {

  File sampleImage;
  String _myValue;
  String url;
  final formType = new GlobalKey<FormState>();

  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
       sampleImage=tempImage;
    });
  }

  bool validateAndSave(){
    final form = formType.currentState;

    if(form.validate()){
      form.save();
      return true;
    }
    else {
      return false;
    }
  }

  //stroring an image in storage
  //get image url
  //go to home page and save data to database
  void uploadStatusImage() async{
    if(validateAndSave()){
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child('Post Images');

      var timeKey=new DateTime.now();

      final StorageUploadTask uploadTask=postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var ImageUrl=await (await uploadTask.onComplete).ref.getDownloadURL();

      url=ImageUrl.toString();
      print("ImageUrl:"+url);

      goToHomePage();
      saveToDatabase();
    }
  }

  //save data inn a realtime database
  void saveToDatabase(){
    var dbTimeKey=new DateTime.now();
    var formatDate=new DateFormat('MMM d, yyyy');
    var formatTime=new DateFormat('EEEE, hh:mm aaa');

    String date=formatDate.format(dbTimeKey);
    String time=formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data={
      "image":url,
      "description":_myValue,
      "date":date,
      "time":time,
    };

    ref.child("Posts").push().set(data);
  }

  //call Homepage
  void goToHomePage(){
     Navigator.push(
        context, 
        MaterialPageRoute(builder: (context){
          return HomePage();
        }
        )
    );
  }

  //design before selecting image
  //if image is selected go to enableUploaad function.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        centerTitle: true,
      ),

      body: Center(
        child: sampleImage == null ? Text('Select an Image') : enableUpload(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  //description text field to add description of an Image
  //validator to check description field
  //by click on Add post button go to uploadStatusImage function
  Widget enableUpload(){
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Form(
        key: formType,

        child: Column(
          children: <Widget>[
            Flexible(
              child: Image.file(sampleImage ,height: 330.0,width: 660.0,),
            ),

            SizedBox(height: 15.0,),

            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),

              validator: (value){
                return value.isEmpty ? ('Description is required') : null;
              },

              onSaved: (value){
                return _myValue=value;
              },
            ),

            SizedBox(height: 15.0,),

            RaisedButton(
              elevation: 10.0,
              child: Text('Add a new Post'),
              textColor: Colors.white,
              color: Colors.pink,

              onPressed: uploadStatusImage,
            ),
          ],
        ),
      ),
    );
  }
}

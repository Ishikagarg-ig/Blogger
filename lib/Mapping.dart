import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'Authentication.dart';
import 'LoginRegisterpage.dart';

class Mapping extends StatefulWidget {

  final AuthImplementation auth;

  Mapping({
    this.auth,
});

  @override
  _MappingState createState() => _MappingState();
}

enum AuthStatus{
 notSignedIn,
 signedIn,
}

class _MappingState extends State<Mapping> {
  AuthStatus authStatus= AuthStatus.notSignedIn;

  //authStatus by checking userID by calling getCurrentUser from Authentication page
  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((firebaseUserId){
      setState(() {
        authStatus=firebaseUserId==null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  //change authStatus
  void _signedIn(){
    setState(() {
      authStatus=AuthStatus.signedIn;
    });
  }

  //change authStatus
  void _signedOut(){
    setState(() {
      authStatus=AuthStatus.notSignedIn;
    });
  }


  //according to authStatus call the pages login/home
  @override
  Widget build(BuildContext context) {
    switch(authStatus)
    {
      case AuthStatus.notSignedIn:
        return LoginRegisterPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );

      case AuthStatus.signedIn:
        return HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
  }
}

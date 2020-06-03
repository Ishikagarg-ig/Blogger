import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'DialogBox.dart';

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

enum FormType{
  login,
  register
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  DialogBox dialogBox = new DialogBox();

  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email="";
  String _password="";

  //methods

  //check validity of email and password
  bool validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }

  //called from login and register.
  //if emailid and password is valid then set the widget to signedIn state and go to authentation page.
  void validateAndSubmit() async{
    if(validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.signIn(_email, _password);
          //dialogBox.information(context, 'Congratulations', 'you are logged in successfully.');
          print("Login userId = " + userId);
        }
        else {
          String userId = await widget.auth.signUp(_email, _password);
          //dialogBox.information(context, 'Congratulations','your account has been created successfully.');
          print("Register userId = " + userId);
        }
        widget.onSignedIn();
      }
      catch (e) {
        dialogBox.information(context, 'Error', e.toString());
        print(e.toString());
      }
    }
  }

  //if want to register from login page
  //change the formType to register
  void moveToRegister(){
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.register;
    });
  }

  //if want to login from register page
  //change the formType to login
  void moveToLogin(){
    formKey.currentState.reset();

    setState(() {
      _formType = FormType.login;
    });
  }


  //design
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
      ),
      body:Padding(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInputs() + createButtons(),
          ),
        ),
      ),
    );
  }


  //create inputs of login
  //validator for emailId and password
  List<Widget> createInputs(){
    return[
      SizedBox(height: 15.0,),
      logo(),
      SizedBox(height: 40.0,),

      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),

        validator: (value){
          return value.isEmpty ? 'Email is Required' : null;
        },

        onSaved: (value){
          return _email=value;
        },
      ),
      SizedBox(height: 10.0,),

      TextFormField(
        decoration: InputDecoration(labelText: 'Password',),
        obscureText: true,

        validator: (value){
          return value.isEmpty ? 'Password is Required' : null;
        },

        onSaved: (value){
          return _password=value;
        },
      ),
      SizedBox(height: 20.0,),
    ];
 }

 //logo of an app
 Widget logo(){
    return Flexible(
      child:Hero(
       tag: 'hero',
       child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius:110.0,
        child: Image.asset('images/logo1.png'),
      ),
      ),
    );
 }


 //login and register button
  //call different functions according to formType
  List<Widget> createButtons(){
    if(_formType==FormType.login){
      return[
        RaisedButton(
          child: Text(
            'Login',
            style: TextStyle(fontSize:20.0),
          ),
          textColor: Colors.white,
          color: Colors.pink,

          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text(
            'Not have an Account? Create Account..',
            style: TextStyle(fontSize:14.0),
          ),
          textColor: Colors.red,

          onPressed: moveToRegister,
        ),
      ];
    }
    else{
      return[
        RaisedButton(
          child: Text(
            'Create Account',
            style: TextStyle(fontSize:20.0),
          ),
          textColor: Colors.white,
          color: Colors.pink,

          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text(
            'Already have an Account? Login',
            style: TextStyle(fontSize:14.0),
          ),
          textColor: Colors.red,

          onPressed: moveToLogin,
        ),
      ];
    }
  }
}

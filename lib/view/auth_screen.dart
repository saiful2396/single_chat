import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/helper_function.dart';
import '../services/auth_methods.dart';
import '../services/database.dart';
import '../models/http_exception.dart';
import '../view/chat_room_screen.dart';

enum AuthMode { SignUp, Login }

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: deviceSize.height,
              width: deviceSize.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFFFC10037),
                      Color(0xFFFF75431),
                      Color(0xFFFC10037),
                    ]),
              ),
            ),
            Positioned(
              top: 130,
              child: Text(
                'Single Chat App',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'BungeeInline',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: deviceSize.height,
              child: Column(
                children: [
                  Container(
                    width: deviceSize.width,
                    height: 250,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AuthCard(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.Login;
  AuthMethods authMethod = AuthMethods();
  DataBaseMethods _dataBase = DataBaseMethods();

  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  AnimationController _animationController;
  Animation<double> _opacityAnimation;
  QuerySnapshot snapshotUserInfo;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'An error occurred',
          style: Theme.of(context).textTheme.headline4,
        ),
        content: Text(
          message,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.SignUp) {
        await authMethod
            .signUpWithEmailAndPassword(
          _emailController.text,
          _userNameController.text,
        )
            .then((value) {
          if (value != null) {
            Map<String, String> _authData = {
              'userEmail': _emailController.text,
              'userName': _userNameController.text,
            };
            _dataBase.addUserInfo(_authData);
            HelperFunctions.saveUserLoggedInSharedPreference(true);
            HelperFunctions.saveUserNameSharedPreference(
                _userNameController.text);
            HelperFunctions.saveUserEmailSharedPreference(
                _emailController.text);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (ctx) => ChatRoom(),
              ),
            );
          }
        });
      } else {
        await authMethod
            .signInWithEmailAndPassword(
            _emailController.text, _passwordController.text)
            .then((result) async {
          if (result != null)  {
            QuerySnapshot userInfoSnapshot =
            await DataBaseMethods().getUserInfo(_emailController.text);

            HelperFunctions.saveUserLoggedInSharedPreference(true);
            HelperFunctions.saveUserNameSharedPreference(
                userInfoSnapshot.docs[0].data()["userName"]);
            HelperFunctions.saveUserEmailSharedPreference(
                userInfoSnapshot.docs[0].data()["userEmail"]);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (ctx) => ChatRoom()),
            );
          }
        });
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'Email already exists';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Invalid email';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Weak password';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Email not found';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you. Please try again later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          )
        : AnimatedContainer(
            height: _authMode == AuthMode.Login ? 350 : 550,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.white,
            ),
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            padding: EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                        '${_authMode == AuthMode.Login ? 'Sing In' : 'Create your account'}'),
                    SizedBox(
                      height: 10,
                    ),
                    if (_authMode == AuthMode.SignUp)
                      TextFormField(
                        controller: _userNameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.text_fields),
                          hintText: 'Enter a username',
                          filled: true,
                          fillColor: Color(0xffdadada),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return value.isEmpty || value.length < 5
                              ? 'Invalid userName!'
                              : null;
                        },
                      ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'E-Mail',
                        filled: true,
                        fillColor: Color(0xffdadada),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (value) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)
                            ? null
                            : "Please enter correct email";
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'Password',
                        filled: true,
                        fillColor: Color(0xffdadada),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        return value.isEmpty || value.length < 5
                            ? 'Password is too short!'
                            : null;
                      },
                    ),
                    SizedBox(height: 10),
                    if (_authMode == AuthMode.Login)
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text('Forget Password?'),
                      ),
                    SizedBox(height: 10),
                    if (_authMode == AuthMode.SignUp)
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.SignUp,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Confirm Password',
                            filled: true,
                            fillColor: Color(0xffdadada),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          obscureText: true,
                          validator: _authMode == AuthMode.SignUp
                              ? (value) {
                                  return value != _passwordController.text
                                      ? 'Passwords do not match!'
                                      : null;
                                }
                              : null,
                        ),
                      ),
                    SizedBox(height: 10),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      RaisedButton(
                        child: Text(
                            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                        onPressed: _submit,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 15.0),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                      ),
                    SizedBox(height: 10),
                    RaisedButton(
                      child: Text(_authMode == AuthMode.Login
                          ? 'SignIn with Google'
                          : 'SIGN UP with Google'),
                      //onPressed: _submit,
                      onPressed: () {
                        // Navigator.of(context)
                        //     .pushReplacementNamed(HomeScreen.routeName);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15.0),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                    ),
                    FlatButton(
                      child: _authMode == AuthMode.Login
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Donn\'t have account? ',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  'SIGN UP',
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have account? ',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  'LOGIN',
                                ),
                              ],
                            ),
                      onPressed: _switchAuthMode,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textColor: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:vediomeet/register_page.dart';

import 'helpers/constants.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController nameController = TextEditingController();

Future updateDeviceToken(String token) async{
  late UserCredential user;
  try{
    FirebaseFirestore.instance.collection('Users').doc(token).update({'device_token': getStringAsync(DEVICE_TOKEN)});
  }on PlatformException catch (e) {
    toast(e.message.toString());
  }
}


Future<String> signIn(String email, String password) async{
  late UserCredential user;
  try{
    user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    print("EMAIL${user.user!.email}");
    setValue(TOKEN, user.user!.uid);
    updateDeviceToken(user.user!.uid);
    HomePage().launch(context);
    }on PlatformException catch (e) {
    toast(e.message.toString());
  }
  return user.user!.uid;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              height: 150,
              width: 300,
              child: Image.asset('assets/images/auth.png', fit: BoxFit.contain,),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: (){
                    RegisterPage().launch(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Colors.brown, fontSize: 20),
                      ),
                      Text(
                        ' SIGN UP',
                        style: TextStyle(
                            color: Colors.brown,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Center(
                        child: TextField(
                          controller: emailController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: ' E M A I L',
                              prefixIcon: Icon(Icons.email, color: Colors.brown),
                              hintStyle: TextStyle(color: Colors.brown, fontSize: 20),
                            )
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Center(
                        child:  TextField(
                          controller: passwordController,
                            decoration:  const InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'P A S S W O R D',
                              prefixIcon: Icon(Icons.lock, color: Colors.brown),
                              hintStyle: TextStyle(color: Colors.brown, fontSize: 20),
                            )
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.brown, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: (){
                          signIn(emailController.text,passwordController.text);
                        },
                        child: Container(
                          color: Colors.brown,
                          child: const Center(
                            child: Text('S I G N  I N',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left:15, right:15, bottom: 20),
                //   child: Row(
                //     children: <Widget>[
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left:10, right:5),
                      //     child: SignInButton(
                      //       Buttons.AppleDark,
                      //       text: "Sign in",
                      //       onPressed: (){
                      //
                      //       },
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left:5, right:5),
                      //     child: SignInButton(
                      //       Buttons.Google,
                      //       text: "Sign in",
                      //       onPressed: (){
                      //
                      //       },
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left:5, right:10),
                      //     child: SignInButton(
                      //       Buttons.Facebook,
                      //       text: "Sign in",
                      //       onPressed: (){
                      //
                      //       },
                      //     ),
                      //   ),
                      // ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ],
      )
    );
  }
}
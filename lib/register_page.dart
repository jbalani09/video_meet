
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:vediomeet/helpers/constants.dart';
import 'package:vediomeet/login_view.dart';

import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future sendDataToCollection(String email, String password,String name,String token) async{
    late UserCredential user;
    try{
      await FirebaseFirestore.instance.collection("Users").doc(token).set({
        'email': email,
        'name': name,
        'password': password,
        'token': token,
        'device_token':getStringAsync(DEVICE_TOKEN)
      });
    }on PlatformException catch (e) {
      toast(e.message.toString());
    }
  }

  Future<String> signUp(String email, String password) async{
    late UserCredential user;
    try{
      user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      sendDataToCollection(email,password,nameController.text,user.user!.uid);
      setValue(TOKEN, user.user!.uid);
      HomePage().launch(context,isNewTask: true);
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
                    onTap : (){
                      LoginScreen().launch(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          'Already have account?',
                          style: TextStyle(color: Colors.brown, fontSize: 20),
                        ),
                        Text(
                          ' SIGN IN',
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
                              controller: nameController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: ' N A M E',
                                prefixIcon: Icon(Icons.person, color: Colors.brown),
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
                            signUp(emailController.text,passwordController.text);
                          },
                          child: Container(
                            color: Colors.brown,
                            child: const Center(
                              child: Text('S I G N  U P',
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

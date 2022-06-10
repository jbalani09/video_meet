import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screens/home_page.dart';
import 'constants.dart';

Future updateDeviceToken(String token) async{
  late UserCredential user;
  try{
    FirebaseFirestore.instance.collection('Users').doc(token).update({'device_token': getStringAsync(DEVICE_TOKEN)});
  }on PlatformException catch (e) {
    toast(e.message.toString());
  }
}


Future<String> signIn(String email, String password, firebaseAuth, BuildContext context) async{
  late UserCredential user;
  try{
    user = await firebaseAuth.signInWithEmailAndPassword(
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

Future<String> signUp(String name,String email, String password,BuildContext context, firebaseAuth) async{
  late UserCredential user;
  try{
    user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    sendDataToCollection(email,password,name,user.user!.uid);
    setValue(TOKEN, user.user!.uid);
    HomePage().launch(context,isNewTask: true);
  }on PlatformException catch (e) {
    toast(e.message.toString());
  }
  return user.user!.uid;
}
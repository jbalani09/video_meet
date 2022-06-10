import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:vediomeet/screens/calling_page.dart';
import '../helpers/app_router.dart';
import '../helpers/navigation_service.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'  as http;

import '../helpers/constants.dart';
import 'login_view.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var _uuid;
  var _currentUuid;
  var textEvents = "";

  List docs = [];

  Future updateDeviceToken(String token) async{
    late UserCredential user;
    try{
      FirebaseFirestore.instance.collection('Users').doc(getStringAsync(TOKEN)).update({'device_token': token});
    }on PlatformException catch (e) {
      toast(e.message.toString());
    }
  }

  Future<void> updateUserData (Map<String, dynamic>values)async{
    String id = values['id'];
    await  FirebaseFirestore.instance.collection('Users').doc(id).set(values, SetOptions(merge: true));
  }

  Future getDocs() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Users").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      docs.add(a);
    }
  }

  @override
  void initState() {
    super.initState();
    _uuid = Uuid();
    _currentUuid = "";
    textEvents = "";
    initCurrentCall();
    updateDeviceToken(getStringAsync(DEVICE_TOKEN));
    listenerEvent(onEvent);
    getDocs().then((value) {
      setState((){});
    });
  }


  static Future<bool> sendFcmMessage(String title, String message,String fcmToken) async {
    try {

      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
        "key=AAAArrqxqUU:APA91bGIDBJuEGSzTd1EvCFZpdV9bD8UBdXCVqULI6ULadiJ5-1gZfXi8SrBqvEZzldbL9RBFgs67PYqArP__d3BB1pAfqizBOf3gb8Ci0sjt6jIIHWZpwlfpxxUfShXKYOtiSEelv_N",
      };
      var request = {
        "notification": {
          "title": title,
          "text": message,
          "sound": "default",
          "color": "#990000",
        },
        'data': {
          'channel_name' : message
        },
        "priority": "high",
        "to": fcmToken,
      };

      var client = http.Client();
      var response =
      await client.post(Uri.parse(url), headers: header, body: json.encode(request));
      print("RESPONSE  $response");
      print("TRUE : ${response.statusCode}");
      return true;
    } catch (e, s) {
      print(e);
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: const Text('Video Meet'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            removeKey(TOKEN);
            LoginScreen().launch(context);
          }, icon: const Icon(Icons.logout,color: Colors.white,))
        ],
      ),
      body: ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
            child: docs[index]['token']==getStringAsync('TOKEN')?null:Card(
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const CircleAvatar(radius: 30,child: Icon(Icons.person,color: Colors.white,),),
                  title: Text(docs[index]['name']),
                  trailing: const Icon(Icons.videocam_rounded,size: 30,color: Colors.blue,),
                  onTap: (){
                    sendFcmMessage(docs[index]['name'],docs[index]['name'],docs[index]['device_token']).then((value) {
                      value?CallingPage().launch(context):toast("Something went wrong");
                    });
                  },
                ),
              ),
            ),
          )
      )
    );
  }

  initCurrentCall() async {
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        _currentUuid = calls[0]['id'];
        return calls[0];
      } else {
        _currentUuid = "";
        return null;
      }
    }
  }

  Future<void> makeFakeCallInComing() async {
    _currentUuid = _uuid.v4();
    print(_currentUuid);

    await Future.delayed(const Duration(seconds: 10), () async {
      _currentUuid = _uuid.v4();
      // print(this._currentUuid);

      var params = <String, dynamic>{
        'id': "65d19658-879c-4ece-9727-3b8dfdcb19fb",
        'nameCaller': 'Hien Nguyen',
        'appName': 'Callkit',
        'avatar': 'https://i.pravatar.cc/100',
        'handle': '0123456789',
        'type': 0,
        'duration': 10000,
        'textAccept': 'Accept',
        'textDecline': 'Decline',
        'textMissedCall': 'Missed call',
        'textCallback': 'Call back',
        'extra': <String, dynamic>{'userId': '1a2b3c4d'},
        'headers': <String, dynamic>{
          'apiKey': 'Abc@123!',
          'platform': 'flutter'
        },
        'android': <String, dynamic>{
          'isCustomNotification': true,
          'isShowLogo': false,
          'isShowCallback': true,
          'isShowMissedCallNotification': true,
          'ringtonePath': 'system_ringtone_default',
          'backgroundColor': '#0955fa',
          'background': 'https://i.pravatar.cc/500',
          'actionColor': '#4CAF50'
        },
        'ios': <String, dynamic>{
          'iconName': 'CallKitLogo',
          'handleType': '',
          'supportsVideo': true,
          'maximumCallGroups': 2,
          'maximumCallsPerCallGroup': 1,
          'audioSessionMode': 'default',
          'audioSessionActive': true,
          'audioSessionPreferredSampleRate': 44100.0,
          'audioSessionPreferredIOBufferDuration': 0.005,
          'supportsDTMF': true,
          'supportsHolding': true,
          'supportsGrouping': false,
          'supportsUngrouping': false,
          'ringtonePath': 'system_ringtone_default'
        }
      };
      await FlutterCallkitIncoming.showCallkitIncoming(params);
    });
  }

  Future<void> endCurrentCall() async {
    initCurrentCall();
    var params = <String, dynamic>{'id': _currentUuid};
    await FlutterCallkitIncoming.endCall(params);
  }

  Future<void> startOutGoingCall() async {
    _currentUuid = _uuid.v4();
    var params = <String, dynamic>{
      'id': _currentUuid,
      'nameCaller': 'Hien Nguyen',
      'handle': '0123456789',
      'type': 1,
      'extra': <String, dynamic>{'userId': '1a2b3c4d'},
      'ios': <String, dynamic>{'handleType': 'number'}
    }; //number/email
    await FlutterCallkitIncoming.startCall(params);
  }

  Future<void> activeCalls() async {
    var calls = await FlutterCallkitIncoming.activeCalls();
    print(calls);
  }

  Future<void> endAllCalls() async {
    await FlutterCallkitIncoming.endAllCalls();
  }

  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
        await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
  }

  Future<void> listenerEvent(Function? callback) async {
    try {
      FlutterCallkitIncoming.onEvent.listen((event) async {
        print('HOME: $event');
        switch (event!.name) {
          case CallEvent.ACTION_CALL_INCOMING:
            // TODO: received an incoming call
            break;
          case CallEvent.ACTION_CALL_START:
            // TODO: started an outgoing call
            // TODO: show screen calling in Flutter
            break;
          case CallEvent.ACTION_CALL_ACCEPT:
            // TODO: accepted an incoming call
            // TODO: show screen calling in Flutter
            // VideoCall(channelName: getStringAsync(CHANNEL_NAME), role: CLIENT_ROLE,);
            NavigationService.instance
                .pushNamedIfNotCurrent(AppRoute.callingPage, args: event.body);
            break;
          case CallEvent.ACTION_CALL_DECLINE:
            // TODO: declined an incoming call
            await requestHttp("ACTION_CALL_DECLINE_FROM_DART");
            break;
          case CallEvent.ACTION_CALL_ENDED:
            // TODO: ended an incoming/outgoing call
            break;
          case CallEvent.ACTION_CALL_TIMEOUT:
            // TODO: missed an incoming call
            break;
          case CallEvent.ACTION_CALL_CALLBACK:
            // TODO: only Android - click action `Call back` from missed call notification
            break;
          case CallEvent.ACTION_CALL_TOGGLE_HOLD:
            // TODO: only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_MUTE:
            // TODO: only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_DMTF:
            // TODO: only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_GROUP:
            // TODO: only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_AUDIO_SESSION:
            // TODO: only iOS
            break;
          case CallEvent.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
            // TODO: only iOS
            break;
        }
        if (callback != null) {
          callback(event.toString());
        }
      });
    } on Exception {}
  }

  Future<void> requestHttp(content) async {
    http.get(Uri.parse(
        'https://webhook.site/2748bc41-8599-4093-b8ad-93fd328f1cd2?data=$content'));
  }

  onEvent(event) {
    if (!mounted) return;
    setState(() {
      textEvents += "${event.toString()}\n";
    });
  }
}

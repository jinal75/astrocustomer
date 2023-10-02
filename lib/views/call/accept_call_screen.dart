import 'dart:async';
import 'dart:developer';

import 'package:AstroGuru/controllers/callController.dart';
import 'package:AstroGuru/main.dart';
import 'package:AstroGuru/utils/images.dart';
import 'package:AstroGuru/views/bottomNavigationBarScreen.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:AstroGuru/utils/global.dart' as global;

import '../../controllers/bottomNavigationController.dart';

class AcceptCallScreen extends StatefulWidget {
  final String astrologerName;
  final int astrologerId;
  final String? astrologerProfile;
  final String token;
  final String callChannel;
  final int callId;
  const AcceptCallScreen({super.key, required this.astrologerName, required this.callId, required this.astrologerId, this.astrologerProfile, required this.token, required this.callChannel});

  @override
  State<AcceptCallScreen> createState() => _AcceptCallScreenState();
}

class _AcceptCallScreenState extends State<AcceptCallScreen> {
  CallController _callController = Get.find<CallController>();

  int uid = 0;
  int? remoteUid;
  int? remoteIdForStop;
  late RtcEngine agoraEngine;
  bool isJoined = false;
  bool isCalling = true;
  Timer? timer;
  Timer? timer2;
  Timer? secTimer;
  bool isMuted = false;
  bool isSpeaker = false;
  int callVolume = 50;
  int? min;
  int? sec;
  int totalSecond = 0;
  bool isHostJoin = false;
  int? localUserId;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 300;

  bool isStart = false;
  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    setupVoiceSDKEngine();
    timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      print('timer call');
      print("local uid " + global.localUid.toString());
      if (global.localUid != null && !isStart) {
        setState(() {
          isStart = true;
        });
        CallController callController = Get.find<CallController>();
        await callController.getAgoraResourceId(widget.callChannel, global.localUid!);
        await callController.getAgoraResourceId2(widget.callChannel, remoteUid!);
        print('start recording');
        await startRecord();
        await startRecord2();
      }
    });

    timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
      _callController.totalSeconds = _callController.totalSeconds + 1;

      _callController.update();
      print('totalsecons $_callController.totalSeconds');
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        global.showToast(
          message: 'Please leave the call by pressing leave button',
          textColor: global.textColor,
          bgColor: global.toastBackGoundColor,
        );
        return false;
      },
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              color: Get.theme.primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          widget.astrologerName,
                          style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500, fontSize: 20),
                        ).translate(),
                        SizedBox(
                          child: status(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  height: 120,
                  width: 120,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: Get.height * 0.1),
                  decoration: BoxDecoration(
                    border: Border.all(color: Get.theme.primaryColor),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 60,
                    child: widget.astrologerProfile == null
                        ? Image.asset(
                            Images.deafultUser,
                            fit: BoxFit.contain,
                            height: 60,
                            width: 40,
                          )
                        : CachedNetworkImage(
                            imageUrl: '${global.imgBaseurl}${widget.astrologerProfile}',
                            imageBuilder: (context, imageProvider) => CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.transparent,
                              child: Image.network(
                                '${global.imgBaseurl}${widget.astrologerProfile}',
                                fit: BoxFit.contain,
                                height: 60,
                              ),
                            ),
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              Images.deafultUser,
                              fit: BoxFit.contain,
                              height: 60,
                              width: 40,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomSheet: Container(
          height: Get.height * 0.1,
          padding: EdgeInsets.all(10),
          color: Get.theme.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    callVolume = 100;
                    isSpeaker = !isSpeaker;
                  });
                  onVolume(isSpeaker);
                },
                child: Icon(
                  Icons.volume_up,
                  color: isSpeaker ? Colors.blue : Colors.grey,
                ),
              ),
              InkWell(
                onTap: () async {
                  print('leave call from cut');
                  global.showOnlyLoaderDialog(Get.context);
                  await leave();
                  global.hideLoader();
                  print('leave call from cut');
                  Get.back();
                  BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
                  bottomNavigationController.setIndex(0, 0);
                  Get.to(() => BottomNavigationBarScreen(
                        index: 0,
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isMuted = !isMuted;
                    log('mute $isMuted');
                  });
                  onMute(isMuted);
                },
                child: Icon(
                  Icons.mic_off,
                  color: isMuted ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setupVoiceSDKEngine() async {
    // retrieve or request microphone permission
    await [Permission.microphone].request();
    //create an instance of the Agora engine
    try {
      agoraEngine = createAgoraRtcEngine();
      await agoraEngine.initialize(RtcEngineContext(appId: global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)));
    } catch (e) {
      print('Exception in setupVoiceSDKEngine:- ${e.toString()}');
    }

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            isJoined = true;
            localUserId = connection.localUid;
            global.localUid = localUserId;
            print('userid : - ${connection.localUid}');
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUId, int elapsed) {
          setState(() {
            isHostJoin = true;
            remoteUid = remoteUId;
            remoteIdForStop = remoteUId;
          });
          callController.isLeaveCall = false;
          callController.update();
          print("RemoteId for call" + remoteUid.toString());
        },
        onUserOffline: (RtcConnection connection, int remoteUId, UserOfflineReasonType reason) async {
          print('leave call from userOffline');
          await leave();
          print('offline : - $remoteUId');
          Get.back();
        },
        onRtcStats: (connection, stats) {},
      ),
    );
    onVolume(isSpeaker);
    onMute(isMuted);
    join();
  }

  Widget status() {
    return CountdownTimer(
      endTime: endTime,
      widgetBuilder: (_, CurrentRemainingTime? time) {
        if (time == null) {
          return const Text('00 min 00 sec');
        }
        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: time.min != null
              ? Text('${time.min} min ${time.sec} sec', style: const TextStyle(fontWeight: FontWeight.w500))
              : Text(
                  '${time.sec} sec',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
        );
      },
      onEnd: () async {
        log('in onEnd ${callController.isLeaveCall}');
        if (callController.isLeaveCall == false) {
          global.showOnlyLoaderDialog(Get.context);
          await leave();
          global.hideLoader();
          Get.back();
          BottomNavigationController bottomNavigationController = Get.find<BottomNavigationController>();
          bottomNavigationController.setIndex(1, 0);
          Get.to(() => BottomNavigationBarScreen(
                index: 0,
              ));
          //call the disconnect method from requested customer
        }
      },
    );
  }

  void join() async {
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    print('in join method of customer call');
    await agoraEngine.joinChannel(
      token: widget.token,
      channelId: widget.callChannel,
      options: options,
      uid: uid,
    );
  }

  Future startRecord() async {
    CallController callController = Get.find<CallController>();
    await callController.agoraStartRecording(widget.callChannel, global.localUid!, widget.token);
  }

  Future startRecord2() async {
    CallController callController = Get.find<CallController>();
    print('stop1 audio recording in live astrologer $remoteIdForStop');
    await callController.agoraStartRecording2(widget.callChannel, remoteIdForStop!, widget.token);
  }

  Future stopRecord() async {
    CallController callController = Get.find<CallController>();
    await callController.agoraStopRecording(widget.callId, widget.callChannel, global.localUid!);
  }

  Future stopRecord2() async {
    CallController callController = Get.find<CallController>();
    print('stop2 audio recording in live astrologer $remoteIdForStop');
    await callController.agoraStopRecording2(widget.callId, widget.callChannel, remoteIdForStop!);
  }

  void onMute(bool mute) {
    agoraEngine.muteLocalAudioStream(mute);
  }

  void onVolume(bool isSpeaker) {
    agoraEngine.setEnableSpeakerphone(isSpeaker);
  }

  Future<void> leave() async {
    print("leave call");
    CallController callController = Get.find<CallController>();
    callController.showBottomAcceptCall = false;
    callController.callBottom = false;
    callController.isLeaveCall = true;
    global.sp!.remove('callBottom');
    global.sp!.setInt('callBottom', 0);
    callController.callBottom = false;
    callController.update();
    log('totalSeconds ${_callController.totalSeconds}');
    await stopRecord();
    await stopRecord2();
    print('final total ${_callController.totalSeconds}');
    print('endcall from leave $remoteUid');
    // if (remoteUid != null) {
    print('endcall API');
    global.showOnlyLoaderDialog(Get.context);
    await callController.endCall(widget.callId, _callController.totalSeconds, global.agoraSid1, global.agoraSid2);
    global.hideLoader();
    // }
    print("mounted called");
    if (mounted) {
      print("mounted called with " + mounted.toString());
      setState(() {
        isJoined = false;
        remoteUid = null;
        global.localUid = null;
      });
    }
    if (timer != null) {
      print('stop timer');
      timer?.cancel();
      timer = null;
    }
    if (timer2 != null) {
      print('stop timer2');
      timer2?.cancel();
      timer2 = null;
    }
    print("leave going to call");
    agoraEngine.leaveChannel();
    print("release going to call");
    agoraEngine.release(sync: true);
    global.localUid = null;
    Get.back();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
      print('stop timer in despose');
      global.localUid = null;
    }
    if (secTimer != null) {
      secTimer!.cancel();
    }
    super.dispose();
  }
}

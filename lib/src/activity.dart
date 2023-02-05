import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class Activity extends StatefulWidget {  @override
  State<StatefulWidget> createState() => _activityState();
}

class _activityState extends State<Activity> {
  Duration duration = Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      duration = Duration(seconds: seconds);
    });
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: 'hours'),
        const SizedBox(
          width: 8,
        ),
        buildTimeCard(time: minutes, header: 'minutes'),
        const SizedBox(
          width: 8,
        ),
        buildTimeCard(time: seconds, header: 'seconds')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 2,),
          Text(
            "elapsed time",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)
          ),
          SizedBox(height: 8,),
          Center(
            child: buildTime()
          ),
          Spacer(flex: 2,),
          buildVitals(),
          Spacer(flex: 2,),
          TextButton(
            child: Text("end night"),
            onPressed: () async {
              String message = "This is a test message!";
              List<String> recipents = ["07421326488"];

              String _result = await sendSMS(message: message, recipients: recipents, sendDirect: true)
                  .catchError((onError) {
                print(onError);
              });
              print(_result);

              // var twilioFlutter = TwilioFlutter(
              //     accountSid : 'AC55814b3b9c08c4a0f0b78d761a986a4c', // replace *** with Account SID
              //     authToken : 'd5e32dff0b5c539e688588b7171eb8fe',  // replace xxx with Auth Token
              //     twilioNumber : '+15744061010'  // replace .... with Twilio Number
              // );
              // twilioFlutter.sendSMS(
              //     toNumber : '+447421326488',
              //     messageBody : 'hello, this is a message from NightGuard');
            },
          ),
          Spacer(flex: 1,),
        ],
      ),
    );
  }

  Widget buildTimeCard({required String time, required String header}) => Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20)
    ),
    child: Text(
      time,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
        fontSize: 72
      )
    )
  );

  Widget buildHeartRate(int heartRate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.monitor_heart,
          color: Colors.white,
          size: 100
        ),
        Column(
          children: [
            Text(
              heartRate.toString(),
              style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              "heart rate",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
            )
          ],
        )
      ],
    );
  }

  Widget buildBodyTemp(double bodyTemp) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
            Icons.thermostat,
            color: Colors.white,
            size: 100
        ),
        Column(
          children: [
            Text(
              bodyTemp.toString(),
              style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              "body temp",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
            )
          ],
        )
      ],
    );
  }

  Widget buildPressure(double pressure) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
            Icons.tire_repair,
            color: Colors.white,
            size: 100
        ),
        Column(
          children: [
            Text(
              pressure.toString(),
              style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              "blood pressure",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
            )
          ],
        )
      ],
    );
  }

  buildVitals() {
    return Column(
      children: [
        buildHeartRate(10),
        SizedBox(height: 10,),
        buildBodyTemp(12.0),
        SizedBox(height: 10,),
        buildPressure(12.0)
      ],
    );
  }
  
}

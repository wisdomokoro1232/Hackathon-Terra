import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:night_watch/src/data_utilities/data_querier.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:vibration/vibration.dart';

class Activity extends StatefulWidget {
  final String number;
  final bool takingDrugs;
  final bool drinkingAlcohol;
  const Activity(
      this.number,
      this.takingDrugs,
      this.drinkingAlcohol,
      {super.key}
  );
  @override
  State<StatefulWidget> createState() => _activityState();
}

class _activityState extends State<Activity> {


  Duration duration = Duration();
  int heartRate = 10;
  double bloodPressure = 12.0;
  double bodyTemp = 12.0;
  bool activeSpike = false;
  Timer? timer;


  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTimeQueryData());
  }

  void spikeResponse() {
    activeSpike = true;
    Future.delayed(const Duration(milliseconds: 10000), () async {
      // Here you can write your code
      String message = "This is an automated message from SpikeGuard, I am in danger and may have been spiked or become ill from drugs";
      List<String> recipients = [widget.number];

      if (activeSpike == true) {
        String _result = await sendSMS(
            message: message, recipients: recipients, sendDirect: true)
            .catchError((onError) {
          print(onError);
        });
        print(_result);
      }

      setState(() {
        // Here you can write your code for open new view
      });

    });
    _showMyDialog();
    Vibration.hasCustomVibrationsSupport().then((hasSupport) => {
      if (hasSupport != null && hasSupport) {
        Vibration.vibrate(duration: 1000)
      }
    });
  }

  void addTimeQueryData() async {
    if (duration.inSeconds.remainder(5) == 0) {
      WearableInfo info = await DataQuerier.getInfo(widget.drinkingAlcohol, widget.takingDrugs);
      heartRate = info.heartRate;
      bloodPressure = info.bloodPressure;
      bodyTemp = info.bodyTemp;
      if (info.spiked) {
        spikeResponse();
      }
    }
    setState(() {
      final seconds = duration.inSeconds + 1;
      duration = Duration(seconds: seconds);
    });

  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Your vitals have indicated you may be in trouble.'),
                Text('Only dismiss this message if you are ok.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Im OK'),
              onPressed: () {
                setState(() {
                  activeSpike = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
              timer?.cancel();
              Navigator.of(context).pop();
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
        buildHeartRate(heartRate),
        SizedBox(height: 10,),
        buildBodyTemp(bodyTemp),
        SizedBox(height: 10,),
        buildPressure(bloodPressure)
      ],
    );
  }
  
}

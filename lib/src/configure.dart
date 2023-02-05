import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'activity.dart';

class Configure extends StatefulWidget {
  const Configure({super.key});



  @override
  State<StatefulWidget> createState() => _configureState();
  
}

class _configureState extends State<Configure> {
  bool takingDrugs = false;
  bool notifyFriends = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 8),
                    const Text(
                        "Are you planning to take drugs?",
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 36, color: Colors.white)
                    ),
                    Switch(
                        value: takingDrugs,
                        onChanged: (bool value) {
                          setState(() {
                            takingDrugs = value;
                          });
                        }),
                    const Spacer(flex: 1),
                    const Text(
                        "Would you like to notify a friend?",
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 36, color: Colors.white)
                    ),
                    Switch(
                        value: notifyFriends,
                        onChanged: (bool value) {
                          setState(() {
                            notifyFriends = value;
                          });
                        }
                    ),
                    const Spacer(flex: 1),
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'friends number'
                      ),
                    ),
                    const Spacer(flex: 1),
                    TextButton(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Activity())
                          );
                        },
                        child: const Text(
                          "start the night",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                        )
                    ),
                    TextButton(onPressed: () async {
                      var result = await Permission.sms.request();
                    }, child: Text("press me")),
                    const Spacer(flex: 8)
                  ]),
            )
        )
    );
  }
}
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
  bool drinkingAlcohol = false;

  final numberEntryController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    numberEntryController.dispose();
    super.dispose();
  }

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
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24, color: Colors.white)
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
                        "Are you planning to drink?",
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24, color: Colors.white)
                    ),
                    Switch(
                        value: drinkingAlcohol,
                        onChanged: (bool value) {
                          setState(() {
                            drinkingAlcohol = value;
                          });
                        }),
                    const Spacer(flex: 1),
                    const Text(
                        "If you'd like to notify a friend enter their number below",
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24, color: Colors.white)
                    ),
                    TextField(
                      controller: numberEntryController,
                      decoration: InputDecoration(
                          hintText: 'friends number'
                      ),
                    ),
                    const Spacer(flex: 2),
                    TextButton(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Activity(numberEntryController.value.text, takingDrugs, drinkingAlcohol))
                          );
                        },
                        child: const Text(
                          "start the night",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                        )
                    ),
                    // TextButton(
                    //     onPressed: () async {
                    //   var result = await Permission.sms.request();
                    // }, child: Text("press me")),
                    const Spacer(flex: 8)
                  ]),
            )
        )
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'configure.dart';

class Introduction extends StatelessWidget {
  const Introduction({super.key});

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
              "Welcome!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36, color: Colors.white)
            ),
            const Spacer(flex: 1),
            const Text(
              "NightGuard is an app designed to keep you safe while you're going out. We use health data from your wearables to detect if you might be in trouble. Whether you're taking drugs and you're cautious about bad side effects, or if you're worried about getting spiked, we've got your back. If there's any unusual changes to your heart rate, body temperature or blood oxygen we can notify your friends.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24, color: Colors.white)
            ),
            const Spacer(flex: 1),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Configure())
                );
              },
              child: const Text(
                "continue",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              )
            ),
            const Spacer(flex: 8)
          ]),
        )
      )
    );
  }

}
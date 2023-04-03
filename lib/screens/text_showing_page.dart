import 'package:flutter/material.dart';

class TextShow extends StatelessWidget {
  final String text;
  const TextShow({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

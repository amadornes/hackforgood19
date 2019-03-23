import 'package:flutter/material.dart';
import 'package:hackforgood19/language_selector.dart';

class TestWidget extends StatelessWidget {
  final void Function(Language) callback;

  const TestWidget(this.callback);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Text("Esto es una prueba."),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => LanguageSelector(true, callback),
          ));
        },
      ),
    );
  }
}

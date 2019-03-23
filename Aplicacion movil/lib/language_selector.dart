import 'package:flutter/material.dart';

class Language {
  final String code, name;

  const Language(this.code, this.name);
}

class LanguageSelector extends StatelessWidget {
  final bool canReturn;
  final void Function(Language) callback;

  const LanguageSelector(this.canReturn, this.callback);

  @override
  Widget build(BuildContext context) {
    final idiomas = [
      Language('ca_CA', 'Catalá'),
      Language('es_ES', 'Español'),
      Language('en_US', 'English'),
      Language('gl_ES', 'Galego'),
      Language('cn_CN', '中文（简体）'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Picker'),
        centerTitle: true,
        leading: canReturn ? IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ) : null,
      ),
      body: ListView.builder(
        itemCount: idiomas.length,
        itemBuilder: (ctx, i) => LanguageEntry(idiomas[i], (lang) {
          callback(lang);
          if(canReturn) {
            Navigator.of(context).pop();
          }
        }),
      ),
    );
  }
}

class LanguageEntry extends StatelessWidget {
  final Language lang;
  final void Function(Language) callback;

  const LanguageEntry(this.lang, this.callback);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Feedback.forLongPress(context);
        callback(lang);
      },
      child: ListTile(
        title: Text(lang.name),
      ),
    );
  }
}

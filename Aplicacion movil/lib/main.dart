import 'package:flutter/material.dart';
import 'package:hackforgood19/language_selector.dart';
import 'package:hackforgood19/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(HFGApp());

class HFGApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hack For Good 2019',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreenWidget(),
    );
  }
}

class HomeScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenWidgetState();

  static HomeScreenWidgetState of(BuildContext context, { bool nullOk = false }) {
    assert(nullOk != null);
    assert(context != null);
    final HomeScreenWidgetState result = context.ancestorStateOfType(const TypeMatcher<HomeScreenWidgetState>());
    if (nullOk || result != null)
      return result;
    throw FlutterError('NOPE');
  }
}

class HomeScreenWidgetState extends State<HomeScreenWidget> {
  String _lang;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return _lang == null
        ? LanguageSelector(false, (lang) {
            setLanguage(lang.code);
          })
        : MainViewWidget((lang) {
            setLanguage(lang.code);
          });
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setLanguage(prefs.getString('lang') ?? null);
    //_setLanguage(null);
  }

  void setLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = code;
    });
    prefs.setString('lang', code);
  }

  String getLanguage() {
    return _lang;
  }

}

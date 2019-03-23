import 'package:barcode_scan/barcode_scan.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackforgood19/fmt.dart';
import 'package:hackforgood19/language_selector.dart';
import 'package:hackforgood19/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';

class MainViewWidget extends StatefulWidget {
  final void Function(Language) callback;

  MainViewWidget(this.callback);

  @override
  _MainViewWidgetState createState() => _MainViewWidgetState(callback);
}

class _MainViewWidgetState extends State<MainViewWidget> {
  final void Function(Language) callback;
  String restaurant;

  _MainViewWidgetState(this.callback);

  @override
  Widget build(BuildContext context) {
    String lang = HomeScreenWidget.of(context).getLanguage();
    return Scaffold(
      appBar: AppBar(
        title: Text('Food For Good'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () => _snap(lang),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Align(
                alignment: Alignment(-1, 1),
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Text(
                    formatMessage(lang, 'options'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            FlatButton(
              child: ListTile(
                title: Text(formatMessage(lang, 'language')),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => LanguageSelector(true, (lang) {
                        callback(lang);
                      }),
                ));
              },
            ),
          ],
        ),
      ),
      body: restaurant != null
          ? restaurant.length == 0
              ? SpinKitCircle(
                  color: Colors.black54,
                  size: 100.0,
                )
              : MenuView(restaurant)
          : Center(
              child: FlatButton(
                onPressed: () => _snap(lang),
                child: Icon(Icons.camera_alt, size: 100),
              ),
            ),
    );
  }

  void _snap(String lang) async {
    final prev = restaurant;
    final result = await BarcodeScanner.scan();
    setState(() {
      this.restaurant = "";
    });

    if (result == null) {
      return;
    }
    if (!RegExp('^[a-zA-Z0-9]+\$').hasMatch(result) || result.length == 0) {
      Fluttertoast.showToast(msg: formatMessage(lang, 'invalid_qr'), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIos: 1, fontSize: 16.0);

      setState(() {
        this.restaurant = prev;
      });
      return;
    }
    Firestore.instance.collection('restaurant').document(result).get().then((snap) {
      if (snap.exists) {
        setState(() {
          this.restaurant = result;
        });
      } else {
        Fluttertoast.showToast(msg: formatMessage(lang, 'invalid_restaurant'), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIos: 1, fontSize: 16.0);
        setState(() {
          this.restaurant = prev;
        });
      }
    });
  }
}

class MenuView extends StatelessWidget {
  final String restaurant;

  const MenuView(this.restaurant);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('restaurant').document(restaurant).collection('item').orderBy('type').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Container();
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (ctx, i) => MenuEntry(snapshot.data.documents[i]),
        );
      },
    );
  }
}

class MenuEntry extends StatefulWidget {
  final DocumentSnapshot data;

  const MenuEntry(this.data);

  @override
  State<StatefulWidget> createState() => _MenuEntryState(data);
}

class _MenuEntryState extends State<MenuEntry> {
  final DocumentSnapshot data;

  _MenuEntryState(this.data);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String lang = HomeScreenWidget.of(context).getLanguage();
    String price = formatCurrency(data['price'], data['currency']);
    return FlatButton(
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          child: data['icon'] == null ? null : Image.network(data['icon']),
        ),
        title: Text(
          data['name'][lang],
          style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xBF000000)),
        ),
        subtitle: Text(price),
        dense: true,
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ExtendedMenuItem(data, lang)));
      },
    );
  }
}

class ExtendedMenuItem extends StatelessWidget {
  final DocumentSnapshot data;
  final String lang;

  const ExtendedMenuItem(this.data, this.lang);

  @override
  Widget build(BuildContext context) {
    String price = formatCurrency(data['price'], data['currency']);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                data['images'] != null
                    ? data['images'].length > 1
                        ? CarouselSlider(
                            items: List.generate(
                                data['images'].length,
                                (i) => FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: data['images'][i],
                                    )),
                            autoPlay: false,
                          )
                        : FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: data['images'][0],
                          )
                    : Container(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      data['name'][lang],
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: const Color(0xAF000000)),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    data['description'][lang],
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: const Color(0x8F000000)),
                  ),
                )
              ],
            ),
          ),
          data['allergens'].length == 0
              ? Container()
              : Container(
                  padding: EdgeInsets.all(10),
                  color: const Color(0x8FFF0000),
                  child: ListTile(
                    leading: Icon(Icons.warning, color: Colors.yellowAccent, size: 40),
                    title: Text(formatMessage(lang, 'allergens')),
                    subtitle: Text(capitalize(data['allergens'].map((e) => formatMessage(lang, 'allergen_${e.documentID}')).join(', '))),
                  ),
                ),
          Container(
            decoration: BoxDecoration(color: const Color(0x1FAA8888)),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.flash_on, color: const Color(0x8F000000)),
                      Text(
                        '  ${data['calories']} kcal',
                        style: TextStyle(color: const Color(0x8F000000)),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.av_timer, color: const Color(0x8F000000)),
                      Text(
                        '  ${data['prepare_time']} min',
                        style: TextStyle(color: const Color(0x8F000000)),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.attach_money, color: const Color(0x8F000000)),
                    Text(
                      '  $price',
                      style: TextStyle(color: const Color(0x8F000000)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Column(children: [
              Align(
                alignment: Alignment(-1, 0),
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 15, 0, 0),
                  child: Text(
                    formatMessage(lang, 'comments'),
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: new Stack(
                  alignment: const Alignment(1.0, 0.0),
                  children: [
                    TextField(
                      decoration: InputDecoration(filled: true, fillColor: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Row(children: [
                    Expanded(
                      child: Text('Paco'),
                    ),
                    Icon(Icons.star, size: 16),
                    Icon(Icons.star, size: 16),
                    Icon(Icons.star, size: 16),
                    Icon(Icons.star_half, size: 16),
                    Icon(Icons.star_border, size: 16)
                  ]),
                  subtitle: Text('Me ha parecío mu bien la verdá'),
                ),
              ),
              Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Row(children: [
                    Expanded(
                      child: Text('Paco'),
                    ),
                    Icon(Icons.star, size: 16),
                    Icon(Icons.star, size: 16),
                    Icon(Icons.star, size: 16),
                    Icon(Icons.star_half, size: 16),
                    Icon(Icons.star_border, size: 16)
                  ]),
                  subtitle: Text('Me ha parecío mu bien la verdá'),
                ),
              ),
              Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Row(children: [
                    Expanded(
                      child: Text('Paco'),
                    ),
                    Icon(Icons.star, size: 16),
                    Icon(Icons.star, size: 16),
                    Icon(Icons.star, size: 16),
                    Icon(Icons.star_half, size: 16),
                    Icon(Icons.star_border, size: 16)
                  ]),
                  subtitle: Text('Me ha parecío mu bien la verdá'),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

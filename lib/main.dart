import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart';

import 'developer.dart';
import 'week_forecast.dart';
import 'search.dart';
import 'settings.dart';
import 'favorites.dart';
import 'weather.dart';

void main() {
  initializeDateFormatting('ru', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        canvasColor: Color(0xFFE2EBFF),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(
        title: '',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {

  double lat = 60;
  double lon = 30;
  String name='';

  setCity(double _lat, double _lon, String _name){
    setState(() {
      lat = _lat;
      lon = _lon;
      name = _name;
    });
  }

  double temp = -17;
  bool done = false;

  Map settings = {'temp': true, 'wind': true, 'preassure': true};

  void setSettings(String key, int val) {
    setState(() {
      settings[key] = val == 0;
    });
  }

  Map data={};
func() {
  setState(() async {
    data = await fetchWeatherData(Client(), lat, lon);
    current = Weather.fromJSON(data['current']);
    log(data['hourly'].length.toString(), name: 'hourly');
    hourly = data['hourly'].map<Weather>((el)=>Weather.fromJSON(el)).toList();
  });
}

  void initState(){
    // Future.delayed(Duration.zero,
    //     (){
    //         setState(() async {
    //           data = await fetchWeatherData(Client(), 60, 30);
    //         });
    //     }
    // );
  }

  Weather current = Weather(temp: 0, pressure: 0, humidity: 0, wind: 0, dt: 0, weatherType: 0);
  List<Weather> hourly = [];
  List<Weather> daily = [];

  @override
  Widget build(BuildContext context) {
    // log(data.toString());
    // if (data.isNotEmpty){
    // }
    return Scaffold(
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  title: Text(
                    'Wheather App',
                    style: GoogleFonts.manrope(fontSize: 18),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(
                    'Настройки',
                    style: GoogleFonts.manrope(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SettingsPage(
                              callback: setSettings,
                              settings: settings,
                            )));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text(
                    'Избранное',
                    style: GoogleFonts.manrope(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => FavoritesPage(
                              title: 'title',
                            )));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text(
                    'О приложении',
                    style: GoogleFonts.manrope(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => DeveloperPage()));
                  },
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder(
          future: Future.delayed(Duration(seconds: 0), () async {
            return await fetchWeatherData(Client(), lat, lon);
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              Future.delayed(Duration(seconds: 2), (){func();});
            return Slide(
            setSettings: setSettings,
            settings: settings,
            setCity: setCity,
            name: name,
            hourly: hourly,
            daily: daily,
            current: current,
          );
          },
        ),
      );
  }
}

class Slide extends StatefulWidget {
  Slide({Key? key,
    required this.current,
    required this.hourly,
    required this.daily,
    required this.settings,
    required this.setSettings,
    required this.setCity,
    required this.name})
      : super(key: key);

  Weather current;
  List<Weather> hourly = [];
  List<Weather> daily = [];

  final Map settings;
  final Function setSettings;
  final Function setCity;
  final String name;




  @override
  _SlideState createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  late bool isOpen = true;
  late bool isClosed = false;


  @override
  Widget build(BuildContext context) {
    // log(widget.hourly.toString(), name: 'hourly');
    return SlidingUpPanel(
      onPanelOpened: () {
        setState(() {
          isOpen = false;
          isClosed = true;
        });
      },
      onPanelClosed: () {
        setState(() {
          isOpen = true;
          isClosed = false;
        });
      },
      color: Color(0xFFE2EBFF),
      minHeight: 300,
      maxHeight: 450,
      panel: Column(children: [
        const Padding(padding: EdgeInsets.only(top: 16)),
        Container(
          height: 4,
          width: 70,
          decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(30))),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 145),
          child: Visibility(
            visible: isClosed,
            child: Row(
              children: [
                Text(
                  "23 сент. 2021",
                  style: GoogleFonts.manrope(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(17.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Neumorphic(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  style: NeumorphicStyle(depth: 5, color: Color(0xFFDEE9FF)),
                  child: Column(
                    children: [
                      Text(
                        DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.hourly[0].dt * 1000)),
                        style: GoogleFonts.manrope(fontSize: 15),
                      ),
                      Image.asset("assets/thunder.png", height: 50, width: 50),
                      Text(
                        widget.hourly.isNotEmpty ? widget.hourly[0].temp.toString() : 'ошибка',
                        style: GoogleFonts.manrope(fontSize: 15),
                      ),
                    ],
                  )),
              Neumorphic(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  style: NeumorphicStyle(depth: 5, color: Color(0xFFDEE9FF)),
                  child: Column(
                    children: [
                      Text(
                        DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.hourly[6].dt * 1000)),
                        style: GoogleFonts.manrope(fontSize: 15),
                      ),
                      Image.asset("assets/thunder.png", height: 50, width: 50),
                      Text(
                        widget.hourly.isNotEmpty ? widget.hourly[6].temp.toString() : 'ошибка',
                        style: GoogleFonts.manrope(fontSize: 15),
                      ),
                    ],
                  )),
              Neumorphic(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  style: NeumorphicStyle(depth: 5, color: Color(0xFFDEE9FF)),
                  child: Column(
                    children: [
                      Text(
                        DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.hourly[12].dt * 1000)),
                        style: GoogleFonts.manrope(fontSize: 15),
                      ),
                      Image.asset("assets/thunder.png", height: 50, width: 50),
                      Text(
                        widget.hourly.isNotEmpty ? widget.hourly[12].temp.toString() : 'ошибка',
                        style: GoogleFonts.manrope(fontSize: 15),
                      ),
                    ],
                  )),
              Neumorphic(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  style: NeumorphicStyle(depth: 5, color: Color(0xFFDEE9FF)),
                  child: Column(
                    children: [
                      Text(
                        DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(widget.hourly[18].dt * 1000)),
                        style: GoogleFonts.manrope(fontSize: 15),
                      ),
                      Image.asset("assets/thunder.png", height: 50, width: 50),
                      Text(
                        widget.hourly.isNotEmpty ? widget.hourly[18].temp.toString() : 'ошибка',
                        style: GoogleFonts.manrope(fontSize: 15),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        Visibility(
          visible: isOpen,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(color: Color(0xFF038CFE), width: 1),
                ),
                child: Text(
                  "Прогноз на неделю",
                  style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: Color(0xFF038CFE),
                      fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ForecastPage(
                    callback: widget.setSettings,
                    settings: widget.settings,
                  )));
                },
              ),
            ),
          ),
          replacement: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: WeatherDetails(widgets: [
                        Icon((Icons.thermostat_outlined)),
                        Text(
                          widget.hourly.isNotEmpty ? widget.hourly[0].temp.toString() : 'ошибка',
                          style: GoogleFonts.manrope(fontSize: 15),
                        ),
                        Text(
                          widget.settings['temp'] ? '°c' : '°F',
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: WeatherDetails(widgets: [
                        Icon((Icons.invert_colors)),
                        Text(
                          widget.hourly.isNotEmpty ? widget.hourly[0].humidity.toInt().toString() : 'ошибка',
                          style: GoogleFonts.manrope(fontSize: 15),
                        ),
                        Text(
                          '%',
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: WeatherDetails(widgets: [
                          Icon((Icons.water_outlined)),
                          Text(
                            widget.hourly.isNotEmpty ? widget.hourly[0].wind.toInt().toString() : 'ошибка',
                            style: GoogleFonts.manrope(fontSize: 15),
                          ),
                          Text(
                            widget.settings['wind'] ? 'м/с' : 'км/ч',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: WeatherDetails(widgets: [
                          Icon((Icons.av_timer)),
                          Text(
                              widget.hourly.isNotEmpty ? widget.hourly[0].pressure.toInt().toString() : 'ошибка',
                            style: GoogleFonts.manrope(fontSize: 15),
                          ),
                          Text(
                            widget.settings['preassure'] ? 'мм.рт.ст' : 'гПа',
                            style: GoogleFonts.manrope(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/backround.png"), fit: BoxFit.fill)),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 35)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Neumorphic(
                  style: NeumorphicStyle(
                      depth: 5,
                      color: Color(0xFF0256FF),
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.all(Radius.circular(100)))),
                  child: IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                      iconSize: 30,
                      color: Colors.white),
                ),
                Visibility(
                  visible: isOpen,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Row(
                      children: [
                        Text(
                          '10',
                          style: GoogleFonts.manrope(
                              fontSize: 80,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.settings['temp'] ? '°c' : '°F',
                          style: GoogleFonts.manrope(
                              fontSize: 80,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isClosed,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(1, 15, 30, 1),
                    child: Text(
                      widget.name,
                      style: GoogleFonts.manrope(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Neumorphic(
                  style: NeumorphicStyle(
                      depth: 5,
                      color: Color(0xFF0256FF),
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.all(Radius.circular(100)))),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SearchPage(widget.setCity)));
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    iconSize: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Visibility(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 120),
                    child: Row(
                      children: [
                        Text(
                          '10',
                          style: GoogleFonts.manrope(
                              fontSize: 80,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.settings['temp'] ? '°c' : '°F',
                          style: GoogleFonts.manrope(
                              fontSize: 80,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  visible: isClosed,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 135),
              child: Visibility(
                visible: isOpen,
                child: Row(
                  children: [
                    Text(
                      "23 сент. 2021",
                      style: GoogleFonts.manrope(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherDetails extends StatelessWidget {
  const WeatherDetails({
    Key? key,
    required this.widgets,
  }) : super(key: key);

  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        padding: EdgeInsets.symmetric(vertical: 23),
        style: NeumorphicStyle(depth: 5, color: Color(0xFFDEE9FF)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets,
        ));
  }
}

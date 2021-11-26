
import 'main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key, @required this.callback, @required this.settings}) : super(key: key);
  final Function callback;
  final Map settings;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int selected1 = 0;
  int selected2 = 0;
  int selected3 = 0;

  @override
  void initState() {
    selected1 = widget.settings['temp'] ? 0 : 1;
    selected2 = widget.settings['wind'] ? 0 : 1;
    selected3 = widget.settings['preassure'] ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Container(
              color: Color(0xFFE2EBFF),
              child: Column(children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_outlined),
                        iconSize: 20,
                        color: Colors.black),
                    SizedBox(
                      width: 18,
                    ),
                    Text('Настройки',
                        style: GoogleFonts.manrope(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600))
                  ],
                ),
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 42, left: 20)),
                    Text('Единицы измерения',
                        style: GoogleFonts.manrope(
                            color: Color(0xFF828282),
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                Container(
                  height: 152,
                  width: 360,
                child: Neumorphic(
                  child: Column(
                    children: [
                      Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 13, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Температура',
                                    style: GoogleFonts.manrope(
                                        color: Color(0xFF333333),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),

                                  ),
                                  Container(
                                    width: 122,
                                    height: 25,
                                    child: NeumorphicToggle(
                                      onChanged: (val){
                                        widget.callback('temp', val);
                                        setState(() {
                                          selected1 = val;
                                        });
                                      },
                                      selectedIndex: selected1,
                                      thumb: Container(
                                        color: Color(0xFF4B5F88),
                                      ),
                                      children: [
                                        ToggleElement(
                                          background: Center(
                                            child: Text(
                                              '°C',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          foreground: Center(
                                            child: Text(
                                              '°С',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ToggleElement(
                                          background: Center(
                                            child: Text(
                                              '°F',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          foreground: Center(
                                            child: Text(
                                              '°F',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      style: NeumorphicToggleStyle(
                                        backgroundColor: Colors.transparent,
                                        lightSource: LightSource.bottom,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 13, left: 20, right: 20),
                              child: Divider(
                                height: 1,
                                color: Color(0xFFC6CEE3),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 13, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Сила ветра',
                                    style: GoogleFonts.manrope(
                                        color: Color(0xFF333333),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),

                                  ),
                                  Container(
                                    width: 122,
                                    height: 25,
                                    child: NeumorphicToggle(
                                      onChanged: (val){
                                        widget.callback('wind', val);
                                        setState(() {
                                          selected2 = val;
                                        });
                                      },
                                      selectedIndex: selected2,
                                      thumb: Container(
                                        color: Color(0xFF4B5F88),
                                      ),
                                      children: [
                                        ToggleElement(
                                          background: Center(
                                            child: Text(
                                              'м/с',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          foreground: Center(
                                            child: Text(
                                              'м/с',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ToggleElement(
                                          background: Center(
                                            child: Text(
                                              'км/ч',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          foreground: Center(
                                            child: Text(
                                              'км/ч',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      style: NeumorphicToggleStyle(
                                        backgroundColor: Colors.transparent,
                                        lightSource: LightSource.bottom,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 13, left: 20, right: 20),
                              child: Divider(
                                height: 1,
                                color: Color(0xFFC6CEE3),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 13, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Давление',
                                    style: GoogleFonts.manrope(
                                        color: Color(0xFF333333),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),

                                  ),
                                  Container(
                                    width: 122,
                                    height: 25,
                                    child: NeumorphicToggle(
                                      onChanged: (val){
                                        widget.callback('preassure', val);
                                        setState(() {
                                          selected3 = val;
                                        });
                                      },
                                      selectedIndex: selected3,
                                      thumb: Container(
                                        color: Color(0xFF4B5F88),
                                      ),
                                      children: [
                                        ToggleElement(
                                          background: Center(
                                            child: Text(
                                              'мм.рт.ст',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          foreground: Center(
                                            child: Text(
                                              'мм.рт.ст',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        ToggleElement(
                                          background: Center(
                                            child: Text(
                                              'гПа',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          foreground: Center(
                                            child: Text(
                                              'гПа',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      style: NeumorphicToggleStyle(
                                        backgroundColor: Colors.transparent,
                                        lightSource: LightSource.bottom,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                    ],
                  ),
                style: NeumorphicStyle(
                  color: Color(0xFFE2EBFF),
                  depth: 3,
                  lightSource: LightSource.top,
                  boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.all(Radius.circular(30))),
                ),
                ),
                ),
              ])),
        ),
      );
}



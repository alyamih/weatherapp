import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';



class DeveloperPage extends StatefulWidget {
  const DeveloperPage({Key key}) : super(key: key);

  @override
  State<DeveloperPage> createState() => _DeveloperPage();
}

class _DeveloperPage extends State<DeveloperPage> {
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                // Padding(padding: EdgeInsets.),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_left),
                      iconSize: 20,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Text(
                      'О разработчике',
                      style: GoogleFonts.manrope(fontSize: 18),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 150),
                          child: Neumorphic(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 52),
                            style: NeumorphicStyle(
                              depth: -4, color: Color(0xFFDEE9FF),
                              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(15)))
                            ),
                            child: Text(
                              'Weather app',
                              style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                          child: Container(
                            width: double.infinity,
                                child: Neumorphic(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 52),
                                  style: NeumorphicStyle(
                                      lightSource: LightSource.bottom,
                                      depth: 5, color: Color(0xFFDEE9FF),
                                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(15)))
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'By ITMO University',
                                        style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        'Версия 1.0',
                                        style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        'от 30 сентября',
                                        style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 295),
                                        child: Column(
                                          children: [
                                            Text(
                                              '2021',
                                              style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          )
                    ],
                  ),
                ),
              ],
            ),
          ),

        ),

      );
}
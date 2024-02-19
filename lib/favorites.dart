import 'package:flutter/material.dart';
import 'main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Container(
            color: Color(0xFFE2EBFF),
            child: Column(
              children: [
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
                    Text('Избранные',
                        style: GoogleFonts.manrope(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  Function callback;

  SearchPage(this.callback);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

Future<List<City>> fetchData(Client client, String text) async {
  final resp = await client.get(Uri.parse(
      'http://api.geonames.org/searchJSON?name_startsWith=$text&maxRows=10&orderby=relevance&username=oksik'));
  final respFromJson = jsonDecode(resp.body)['geonames'];
  // log(respFromJson[0].toString(), name: 'respFromJson');
  return respFromJson.map<City>((json) => City.fromJSON(json)).toList();
}

class City {
  var name = '';
  var country = '';
  var lat = 0.0;
  var lon = 0.0;

  factory City.fromJSON(Map<String, dynamic> json) {
    // log(json.toString());
    return City(name: json['toponymName'], country: json['countryName'],
        lat: double.parse(json['lat']), lon: double.parse(json['lng']));
  }


  static List<City> decode(String fav) =>
      (json.decode(fav) as List<dynamic>)
          .map<City>((city) => City.fromJSONCustom(city)).toList();

  factory City.fromJSONCustom(Map<String, dynamic> parsed) {
    return City(
        name: parsed['name'],
        country: parsed['country'],
        lat: parsed['lat'],
        lon: parsed['lng'],
    );
  }

  City({@required this.name, @required this.country, @required this.lat, @required this.lon});

  @override
  String toString() {
    return 'City{name: $name, country: $country, lat: $lat, lon: $lon}';
  }
}

Map<String, dynamic> toMap(City cities) {
  return {
    'name': cities.name,
    'country': cities.country,
    'lat': cities.lat,
    'lon': cities.lon,
  };
}


class _SearchPageState extends State<SearchPage> {
  final globalKey = GlobalKey<ScaffoldState>();
  String text = '';
  List<bool> addFavorite = <bool>[];

  void initState() {
    super.initState();
    loadFavourites();
  }

  void saveFavourites(List<City> favourites) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String fav = encode(favourites);
      prefs.setString('Favourites', fav);
    });
  }

  List<City> favourites = [];


  String encode(List<City> f) =>
      json.encode(
          f.map<Map<String, dynamic>>((f) => toMap(f)).toList()
      );

  void loadFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favourites = City.decode(prefs.getString('Favourites') ?? '');
    });
    // log(favourites.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
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
                  LimitedBox(
                    maxWidth: 320,
                    child: CupertinoSearchTextField(
                      placeholder: "Введите название города",
                      onSubmitted: (value) {
                        setState(() {
                          text = value;
                        });
                        fetchData(Client(), value);
                      },
                    ),
                  ),
                ],
              ),
              Container(
                height: 500,
                child: FutureBuilder<List<City>>(
                  future: fetchData(Client(), text),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // log(snapshot.toString(), name: 'snapshot');
                      List<City> data = snapshot.data;
                      // log(data.toString());
                      if (data.isNotEmpty) {
                        return Container(
                          width: 360,
                          height: 640,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                    height: 1,
                                    color: Color(0xFFC6CEE3),
                                    thickness: 1,
                                  ),
                              itemBuilder: (BuildContext context, int index) {
                                addFavorite.add(false);
                                return Container(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            widget.callback(
                                                data[index].lat,
                                                data[index].lon,
                                                data[index].name);
                                            saveFavourites(favourites);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    data[index].name +
                                                        ", " +
                                                        data[index].country,
                                                    overflow: TextOverflow.fade,
                                                    style: GoogleFonts.manrope(
                                                        color:
                                                        Color(0xFF333333),
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w600),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(addFavorite
                                                      .elementAt(index)
                                                      ? Icons.star
                                                      : Icons
                                                      .star_border_outlined),
                                                  onPressed: () {
                                                    loadFavourites();
                                                    setState(() {
                                                      addFavorite[index] =
                                                      addFavorite[index] ==
                                                          false
                                                          ? true
                                                          : false;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: data.length,
                            ),
                          ),
                        );
                      }
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


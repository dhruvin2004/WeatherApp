import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_icons/weather_icons.dart';

import 'global.dart';


void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff7C91BB),
          elevation: 0,
          titleTextStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  num temp = 0;
  num lon = 0;
  num lat = 0;
  num speed = 0;
  num tempMin = 0;
  num tempMax = 0;
  num press = 0;
  num hum = 0;
  num cover = 0;
  num visibility = 0;

  String cityname = "";

  DateTime dateTime = DateTime.now();

  getCityWeather(String cityname) async {
    var client = http.Client();
    var uri = '${Global.domain}q=$cityname&appid=${Global.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = json.decode(data);
      updateUI(decodeData);
      print(data);
    } else {
      print(response.statusCode);
    }
  }



  updateUI(var decodedData) {
    setState(() {
      if (decodedData == null) {
        temp = 0;
        lon = 0;
        speed = 0;
        lat = 0;
        tempMin = 0;
        tempMax = 0;
        press = 0;
        hum = 0;
        cover = 0;
        visibility = 0;

        cityname = 'Not available';
      } else {
        temp = decodedData['main']['temp'] - 273;
        tempMin = decodedData['main']['temp_min'];
        tempMax = decodedData['main']['temp_max'];
        press = decodedData['main']['pressure'];
        hum = decodedData['main']['humidity'];
        cover = decodedData['clouds']['all'];
        lon = decodedData['coord']['lon'];
        lat = decodedData['coord']['lat'];
        speed = decodedData['wind']['speed'];

        cityname = decodedData['name'];
        visibility = decodedData['visibility'];
      }
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      backgroundColor: const Color(0xff7C91BB),
      body: RefreshIndicator(
        onRefresh: () async{
          await getCityWeather(cityname);
        },
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            Container(
              height: 35,
              width: w,
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 35,
                    width: w - 80,
                    margin: const EdgeInsets.only(
                      left: 5,
                    ),
                    child: TextFormField(
                      controller: Global.cityController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.grey)),
                      onFieldSubmitted: (String name) async {
                        setState(() {
                          cityname = name;
                          getCityWeather(name);
                          Global.cityController.clear();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  cityname,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 30),
                ),
                const Spacer(),
                Text("${dateTime.hour} : ${dateTime.minute} PM",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff546A96),
                      fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 200,
              width: w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                    image: NetworkImage(
                      "https://i.pinimg.com/originals/a7/f0/d4/a7f0d449cf9d1e9a47a64306e50fac32.png",
                    ),
                    fit: BoxFit.fill),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${temp.toInt()}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 45)),
                      const Text(
                        " ºC",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 30),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("LON : ${lon.toDouble()}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff546A96),
                              fontSize: 15)),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "LAN : ${lat}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xff546A96),
                            fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  height: 180,
                  width: w / 2.2,
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xff9CB1D2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: const [
                            BoxedIcon(
                              WeatherIcons.barometer,
                              color: Color(0xff546A96),
                            ),
                            Text(
                              "PRESSURE",
                              style: TextStyle(
                                  color: Color(0xff546A96),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        "${press}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  height: 180,
                  width: w / 2.2,
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xff9CB1D2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: const [
                             BoxedIcon(
                              WeatherIcons.humidity,
                              color: Color(0xff546A96),
                            ),
                             Text(
                              "HUMBIDITY",
                              style: TextStyle(
                                  color: Color(0xff546A96),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        "${hum}%",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 180,
              width: w / 2.2,
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xff9CB1D2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: const [
                           BoxedIcon(
                            WeatherIcons.direction_up,
                            color: Color(0xff546A96),
                          ),

                           Text(
                            "MAX TEMP",
                            style: TextStyle(
                                color: Color(0xff546A96),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                           BoxedIcon(
                            WeatherIcons.direction_down,
                            color: Color(0xff546A96),
                          ),
                           Text(
                            "MIN TEMP",
                            style: TextStyle(
                                color: Color(0xff546A96),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${tempMax.toInt()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40),
                      ),
                      Text(
                        "${tempMin.toInt()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  height: 180,
                  width: w / 2.2,
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xff9CB1D2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: const[
                             BoxedIcon(
                              WeatherIcons.cloud,
                              color: Color(0xff546A96),
                            ),
                             Text(
                              "CLOUDE",
                              style: TextStyle(
                                  color: Color(0xff546A96),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "${cover}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  height: 180,
                  width: w / 2.2,
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xff9CB1D2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: const[
                             BoxedIcon(
                              WeatherIcons.cloudy_windy,
                              color: Color(0xff546A96),
                            ),
                             Text(
                              "WIND SPEED",
                              style: TextStyle(
                                  color: Color(0xff546A96),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "${speed}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  height: 180,
                  width: w / 2.2,
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xff9CB1D2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: const [
                             Icon(
                              Icons.remove_red_eye,
                              color: Color(0xff546A96),
                            ),
                             Text(
                              "VISIBILITY",
                              style: TextStyle(
                                  color: Color(0xff546A96),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "${visibility}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

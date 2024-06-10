import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {
  final String place;
  const Result({
    super.key,
    required this.place,
  });

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  Future<Map<String, dynamic>> getDataFromAPI() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${widget.place}&appid=b5d56e36f4a97e02069f1f679ad341a2&units=metric"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Error fetching weather data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Weather Result",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 103.0, right: 103.0),
          child: FutureBuilder(
            future: getDataFromAPI(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Nama: ${data["name"]}",
                        style: TextStyle(fontSize: 24)),
                    SizedBox(height: 20),
                    Text("Awan: ${data["weather"]["main"]}",
                        style: TextStyle(fontSize: 24)),
                    SizedBox(height: 20),
                    Text("Suhu: ${data["main"]["feels_like"]} °C",
                        style: TextStyle(fontSize: 24)),
                    SizedBox(height: 20),
                    Text(
                      "Kecepatan Angin: ${data["wind"]["speed"]} m/s",
                      style: TextStyle(fontSize: 18),
                    ),
                    Image(
                      image: NetworkImage(
                          'https://flagsapi.com/${data["sys"]["country"]}/shiny/64.png'),
                    )
                  ],
                );
                // } else if (snapshot.hasError) {
                //   return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                return const Center(child: Text("Tempat tidak ditemukan"));
              }
            },
          ),
        ),
      ),
    );
  }
}

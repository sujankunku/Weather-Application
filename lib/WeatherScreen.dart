import "dart:convert";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:weatherapp/AdditionalinfoItem.dart";
import "package:weatherapp/HourlyForecastItem.dart";
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  Future<Map<String, dynamic>> getWeatherData() async {
    final result = await http.get(
      Uri.parse(
        "https://api.weatherapi.com/v1/forecast.json?q=india&key=318127251eb84497ab6172323242701",
      ),
    );
    final data = jsonDecode(result.body);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                getWeatherData();
              });
            },
            icon: const Icon(
              Icons.replay_outlined,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getWeatherData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final currTemp = data['current']['temp_c'];
          final currSky = data['current']['condition']['text'];
          //final currIcon = data['current']['condition']['icon'];
          final currWind = data['current']['wind_kph'];
          final currPressure = data['current']['pressure_mb'];
          final currhumidity = data['current']['humidity'];
          print(currTemp);
          // snapshot.hasError;{
          //   throw Text(snapshot.error.toString());
          // }
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shadowColor: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$currTemp C',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: currSky == 'Rain' || currSky == 'clear'
                                  ? const Icon(Icons.cloud_sharp)
                                  : const Icon(Icons.sunny, size: 50),
                            ),
                            const Expanded(
                              child: SizedBox(
                                height: 8,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                currSky,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                // SizedBox(height: 0),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: ((context, index) {
                      final date = DateTime.parse(data['forecast']
                          ['forecastday'][0]['hour'][index + 1]['time']);
                      final hfTime = DateFormat.Hm().format(date);
                      final hfTemp = data['forecast']['forecastday'][0]['hour']
                          [index + 1]['temp_c'];
                      final hfSky = data['forecast']['forecastday'][0]['hour']
                          [index + 1]['condition']['text'];

                      return HourlyForecast(
                        icon: hfSky == 'Clear' || hfSky == 'Cloudy'
                            ? Icons.cloud_sharp
                            : Icons.sunny,
                        info: '${hfTemp}c',
                        value: hfTime.toString(),
                      );
                    }),
                  ),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       HourlyForecast(
                //         icon: Icons.cloud,
                //         info: "Rain",
                //         value: "300.09 F",
                //       ),
                //       HourlyForecast(
                //         icon: Icons.sunny,
                //         info: "Rain",
                //         value: "300.09 F",
                //       ),
                //       HourlyForecast(
                //         icon: Icons.thunderstorm_rounded,
                //         info: "Rain",
                //         value: "300.09 F",
                //       ),
                //       HourlyForecast(
                //         icon: Icons.cloud,
                //         info: "Rain",
                //         value: "300.09 F",
                //       ),
                //       HourlyForecast(
                //         icon: Icons.cloud,
                //         info: "Rain",
                //         value: "300.09 F",
                //       ),
                //       HourlyForecast(
                //         icon: Icons.cloud,
                //         info: "Rain",
                //         value: "300.09 F",
                //       ),
                //       HourlyForecast(
                //         icon: Icons.cloud,
                //         info: "Rain",
                //         value: "300.09 F",
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AdditionalInfoItem(
                        icon: Icons.water_drop,
                        info: "Humidity",
                        value: currhumidity.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.air,
                        info: "Wind Speed",
                        value: currWind.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.beach_access,
                        info: "Pressure",
                        value: currPressure.toString(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_api_weather/models/weather_model.dart';
import 'package:flutter_api_weather/service/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService(apiKey);
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
      //catch errors
    } catch (e) {
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunshine_animation.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy_animation.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/overcast_animation.json';
      case 'thunderstorm':
        return 'assets/thunder_animation.json';
      case 'clear':
        return 'assets/sunshine_animation.json';
      default:
        return 'assets/sunshine_animation.json';
    }
  }

  // initial state
  @override
  void initState() {
    super.initState();

    // fetch the weather
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // city name
              Text(
                _weather?.cityName ?? "Loading City...",
                style: const TextStyle(color: Colors.white),
              ),
              // animation
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              // temperature
              Text('${_weather?.temperature.round()}°C',
                  style: const TextStyle(color: Colors.white)),
              // weather condition
              Text(_weather?.mainCondition ?? "",
                  style: const TextStyle(color: Colors.white)),
              // weather description
              Text(_weather?.description ?? "",
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ));
  }
}

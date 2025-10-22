// lib/providers/weather_provider.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final weatherProvider = FutureProvider<String>((ref) async {
  try {
    // Vérifier le service de localisation
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Localisation désactivée';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Permission refusée';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Permission bloquée';
    }

    // Obtenir la position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10), // Timeout
    );

    // Appeler OpenWeatherMap
    const apiKey = 'd1c81e2855e20f9fb16fbca1ca787324';
    final url = 'https://api.openweathermap.org/data/2.5/weather'
        '?lat=${position.latitude}&lon=${position.longitude}'
        '&appid=$apiKey&units=metric&lang=fr';

    final response = await http.get(Uri.parse(url)).timeout(
          const Duration(seconds: 10),
        );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final temp = data['main']['temp'];
      final desc = data['weather'][0]['description'];
      return '${temp.toStringAsFixed(1)}°C - ${desc.toUpperCase()}';
    } else {
      return 'Erreur ${response.statusCode}';
    }
  } on TimeoutException {
    return 'Délai dépassé (émulateur ?)';
  } catch (e) {
    return 'Erreur: $e';
  }
});

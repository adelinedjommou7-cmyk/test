import 'dart:convert';
import 'package:example/models/ressources.dart';
import 'package:flutter/services.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<List<Ressources>> getActivities() async {
    // Charger le fichier JSON depuis les assets
    final jsonString =
        await rootBundle.loadString('assets/json/ressources.json');
    List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData
        .map<Ressources>((json) => Ressources.fromJson(json))
        .toList();
  }

  Future<List<Ressources>> getActivity() async {
    // Charger le fichier JSON depuis les assets
    final jsonString = await rootBundle.loadString('assets/json/activity.json');
    List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData
        .map<Ressources>((json) => Ressources.fromJson(json))
        .toList();
  }

  Future<List<Ressources>> getPage({int page = 0, int pageSize = 10}) async {
    // Charger le fichier JSON depuis les assets
    final jsonString = await rootBundle.loadString('assets/data.json');
    List<dynamic> jsonData = jsonDecode(jsonString);
    // Calculer la plage de données à retourner
    int start = page * pageSize;
    int end = start + pageSize;
    if (start > jsonData.length) return [];
    if (end > jsonData.length) end = jsonData.length;
    List<dynamic> pageData = jsonData.sublist(start, end);
    return pageData
        .map<Ressources>((json) => Ressources.fromJson(json))
        .toList();
  }
}

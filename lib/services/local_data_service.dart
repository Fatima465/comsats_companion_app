import 'package:shared_preferences/shared_preferences.dart';

class LocalDataService {
  // Save CGPA
  static Future<void> saveCgpa(double cgpa) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('user_cgpa', cgpa);
  }

  // Get CGPA
  static Future<double?> getCgpa() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('user_cgpa');
  }

  // Save Planner Data (e.g., a simple String of JSON)
  static Future<void> savePlannerData(String jsonString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('planner_data', jsonString);
  }

  // Get Planner Data
  static Future<String?> getPlannerData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('planner_data');
  }
}
class ApiConfig {
  static const String baseUrl = 'http://192.168.1.6:8000/api';

  static const String userEndpoint = "$baseUrl/user";
  static const String manualAgeEndpoint = "$baseUrl/submit-age-manual";
  static const String profileEndpoint = "$baseUrl/profile";
  static String workoutsCategoryEndpoint(int userId) =>
      "$baseUrl/workouts/categories/$userId";
}

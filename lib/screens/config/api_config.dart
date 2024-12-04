class ApiConfig {
  static const String baseUrl = 'http://192.168.1.6:8000/api';

  static const String userEndpoint = "$baseUrl/user";
  static const String manualAgeEndpoint = "$baseUrl/submit-age-manual";
  static const String profileEndpoint = "$baseUrl/profile";
  static const String selectProgramEndpoint = "$baseUrl/workouts/select";

  static String workoutsCategoryEndpoint(int userId) =>
      "$baseUrl/workouts/categories/$userId";

  static String checkCategoryStatusEndpoint(int userId, int workoutsId) {
    return '$baseUrl/categoryStatus/$userId/$workoutsId';
  }

  // static String workoutsDetailsEndpoint(String category) {
  //   return '$baseUrl/workouts/details?category=$category';
  // }

  static String workoutsDetailsEndpoint(int workoutsId) {
    return '$baseUrl/workout-details/$workoutsId';
  }

  static String startProgramEndpoint = '$baseUrl/start-program';
}

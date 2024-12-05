class ApiConfig {
  static const String baseUrl = 'http://192.168.69.120:8000/api';

  static const String userEndpoint = "$baseUrl/user";
  static const String manualAgeEndpoint = "$baseUrl/submit-age-manual";
  static const String profileEndpoint = "$baseUrl/profile";
  static const String selectProgramEndpoint = "$baseUrl/workouts/select";
  static String startProgramEndpoint = '$baseUrl/start-program';

  static String workoutsCategoryEndpoint(int userId) =>
      "$baseUrl/workouts/categories/$userId";

  static String checkCategoryStatusEndpoint(int userId, int workoutsId) {
    return '$baseUrl/categoryStatus/$userId/$workoutsId';
  }

  static String workoutsDetailsEndpoint(int workoutsId) {
    return '$baseUrl/workout-details/$workoutsId';
  }

  // Endpoint untuk mendapatkan langkah-langkah latihan
  static String workoutsStepsEndpoint(
      int userId, int workoutsId, int dayNumber) {
    return '$baseUrl/workouts/$userId/$workoutsId/steps/$dayNumber';
  }

  // Endpoint untuk mengupdate status latihan
  static String updateWorkoutUserDayNumberEndpoint() {
    return '$baseUrl/workouts/update-progress';
  }
}

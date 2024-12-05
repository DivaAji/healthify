// registration_event.dart

abstract class RegistrationEvent {}

class RegisterUserEvent extends RegistrationEvent {
  final String username;
  final String password;
  final String email;
  final String gender;
  final String weight;
  final String height;
  final String age;
  final String ageRange;

  RegisterUserEvent({
    required this.username,
    required this.password,
    required this.email,
    required this.gender,
    required this.weight,
    required this.height,
    required this.age,
    required this.ageRange,
  });
}

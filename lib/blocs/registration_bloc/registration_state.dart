// registration_state.dart

abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationInProgress extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final int userId;
  RegistrationSuccess({required this.userId});
}

class RegistrationFailure extends RegistrationState {
  final String message;
  RegistrationFailure({required this.message});
}

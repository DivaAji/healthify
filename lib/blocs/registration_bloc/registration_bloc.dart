import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthify/blocs/registration_bloc/registration_event.dart';
import 'package:healthify/blocs/registration_bloc/registration_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial());

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is RegisterUserEvent) {
      yield RegistrationInProgress(); // State to show loading indicator

      try {
        // Simulate API call to register user
        final response = await http.post(
          Uri.parse('http://192.168.1.6:8000/api/user'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': event.username,
            'email': event.email,
            'password': event.password,
            'gender': event.gender,
            'weight': event.weight,
            'height': event.height,
            'age': event.age,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          if (responseData.containsKey('data') &&
              responseData['data'].containsKey('user_id')) {
            final userId = responseData['data']['user_id'];
            yield RegistrationSuccess(userId: userId); // On success
          } else {
            yield RegistrationFailure(
                message: 'User ID not found.'); // On failure
          }
        } else {
          yield RegistrationFailure(
              message: 'Registration failed.'); // On failure
        }
      } catch (e) {
        yield RegistrationFailure(
            message: 'An error occurred: $e'); // On exception
      }
    }
  }
}

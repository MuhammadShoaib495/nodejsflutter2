import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    // Register the handler for the LoginRequested  Event
    on<LoginRequested>(_onLoginRequested);
  }

  // Store Token in shared Prefs files
 Future<void> storeToken(String token, String username, String userid) async {
    final prefs = await SharedPreferences.getInstance();
    // Store the JWT, username, and userId in SharedPreferences
    await prefs.setString('jwtToken', token);
    await prefs.setString('username', username);
    await prefs.setString('userid', userid);

 }
  // Future fetching
  Future<void> _onLoginRequested(LoginRequested event,
      Emitter<LoginState> emit,) async {
  emit(LoginLoading());
  try {
    final response = await http.post(
        Uri.parse('http://localhost:3600/api/login'),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode({
      'username': event.username,
      'password': event.password,
    }));
    if(response.statusCode == 200) {
      final userDetails = json.decode(response.body);
      final token = userDetails['token'];
      final userid = userDetails['userid'];
      final username = userDetails['username'];
      await storeToken(token, userid, username);// store token
      emit(LoginSuccess(userDetails));
    } else {
      emit(LoginFailure("Invalid Credentials, Please Try Again"));
    }
  } catch(e) {
    emit(LoginFailure("An error Occurred: $e "));
  }
  }
}

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}
// When user is modifying the input of the email field
class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'LoginEmailChanged { email :$email }';
}
// Same for the password field
class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'LoginPasswordChanged { password: $password }';
}

// When the user tap on the Google Icon to Login
class LoginWithGooglePressed extends LoginEvent {}

// When the user tap on the Login button
class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginWithCredentialsPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }
}
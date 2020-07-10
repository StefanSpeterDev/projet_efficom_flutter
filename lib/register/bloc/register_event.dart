import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'RegisterEmailChanged { email :$email }';
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'RegisterPasswordChanged { password: $password }';
}

class RegisterFirstNameChanged extends RegisterEvent {
  final String firstname;

  const RegisterFirstNameChanged({@required this.firstname});

  @override
  List<Object> get props => [firstname];

  @override
  String toString() => 'RegisterFirstNameChanged { firstname: $firstname }';
}

class RegisterLastNameChanged extends RegisterEvent {
  final String lastname;

  const RegisterLastNameChanged({@required this.lastname});

  @override
  List<Object> get props => [lastname];

  @override
  String toString() => 'RegisterLastNameChanged { lastname: $lastname }';
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String firstname;
  final String lastname;

  const RegisterSubmitted({
    @required this.email,
    @required this.password,
    @required this.firstname,
    @required this.lastname,
  });

  @override
  List<Object> get props => [email, password, firstname, lastname];

  @override
  String toString() {
    return 'RegisterSubmitted { email: $email, password: $password, firstname $firstname, lastname $lastname }';
  }
}

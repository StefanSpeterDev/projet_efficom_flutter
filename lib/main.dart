import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_efficom/authentication_bloc/authentication_event.dart';
import 'package:projet_efficom/bloc_delegate.dart';
import 'package:projet_efficom/repositories/user_repository.dart';
import 'app/app.dart';
import 'authentication_bloc/authentication_bloc.dart';

void main() {
  // required to use any plugins if the code is executed before runApp
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AuthenticationStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}
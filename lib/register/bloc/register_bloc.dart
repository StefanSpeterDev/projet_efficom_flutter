import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:projet_efficom/models/validators.dart';
import 'package:projet_efficom/register/bloc/bloc.dart';
import 'package:projet_efficom/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.initial();

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
    Stream<RegisterEvent> events,
    TransitionFunction<RegisterEvent, RegisterState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! RegisterEmailChanged &&
          event is! RegisterPasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is RegisterEmailChanged ||
          event is RegisterPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapRegisterEmailChangedToState(event.email);
    } else if (event is RegisterPasswordChanged) {
      yield* _mapRegisterPasswordChangedToState(event.password);
    } else if (event is RegisterFirstNameChanged) {
      yield* _mapRegisterFirstNameChangedToState(event.firstname);
    } else if (event is RegisterLastNameChanged) {
      yield* _mapRegisterLastNameChangedToState(event.lastname);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(event.email, event.password, event.firstname, event.lastname);
    }
  }

  Stream<RegisterState> _mapRegisterEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapRegisterPasswordChangedToState(
      String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapRegisterFirstNameChangedToState(
      String firstname) async* {
    yield state.update(
      isFirstNameValid: Validators.isValidFirstName(firstname),
    );
  }

  Stream<RegisterState> _mapRegisterLastNameChangedToState(
      String lastname) async* {
    yield state.update(
      isLastNameValid: Validators.isValidLastName(lastname),
    );
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
    String email,
    String password,
    String firstname,
    String lastname,
  ) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(
        email: email,
        password: password,
        firstname: firstname,
        lastname: lastname,
      );
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}

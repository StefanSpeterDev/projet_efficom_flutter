class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static final _nameRegex = RegExp(r'^[a-zA-Z]+(([\W][a-zA-Z ])?[a-zA-Z]*)*$');



  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidFirstName(String name){
    return _nameRegex.hasMatch(name);
  }
  static isValidLastName(String name){
    return _nameRegex.hasMatch(name);
  }
}
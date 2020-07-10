class User {

  final String id;
  final String firstname;
  final String lastname;
  final String email;

  User(this.id, this.firstname, this.lastname, this.email);

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        firstname = data['firstname'],
        email = data['email'],
        lastname = data['lastname'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'email': email,
      'lastname': lastname,
    };
  }
}
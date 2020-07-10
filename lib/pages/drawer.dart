import 'package:flutter/material.dart';
import 'package:projet_efficom/repositories/user_repository.dart';

class AppDrawer extends StatefulWidget {
  final UserRepository userRepository;

  const AppDrawer({Key key, this.userRepository}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState(this.userRepository);
}

class _AppDrawerState extends State<AppDrawer> {
 final UserRepository _userRepository;

  _AppDrawerState(this._userRepository);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(_userRepository.getUser().toString()),
            accountName: Text('Stefan Speter'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://avatars3.githubusercontent.com/u/32258096?s=460&u=af555943b9efdd29e6e74f6aab41d3fa31cbebc4&v=4"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Mon profil'),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('About my app'),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );

  }
}

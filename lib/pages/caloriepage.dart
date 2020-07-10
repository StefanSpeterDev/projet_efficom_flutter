import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:projet_efficom/authentication_bloc/bloc.dart';
import 'package:projet_efficom/pages/drawer.dart';

class CaloriePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(builder: (_) => CaloriePage());
  }

  CaloriePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CaloriePageState createState() => new _CaloriePageState();
}

class _CaloriePageState extends State<CaloriePage> {
  int calorieBase;
  int calorieActivite;
  int radioSelector;
  double weight;
  double yearOld;
  bool sexe = false;
  double size = 170.0;
  Map mapActivite = {0: "Faible", 1: "Modere", 2: "Forte"};

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      // permet de quitter le clavier en cliquant en sur l'écran (abs de btn retour sur IOS)
      onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
      child: new Scaffold(
          drawer: AppDrawer(),
          appBar: new AppBar(
            title: new Text('Bienvenue ${widget.title}'),
            centerTitle: true,
            backgroundColor: setColor(),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    AuthenticationLoggedOut(),
                  );
                },
              )
            ],
          ),
          body: new SingleChildScrollView(
              padding: EdgeInsets.all(15.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  gentextWithStyle(
                      "Remplisser tous les champs pour obtenir votre besoin journalier en caloris"),
                  new Card(
                    elevation: 10.0,
                    child: new Column(
                      children: <Widget>[
                        padding(),
                        // Choix du sexe de l'utilisateur
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            gentextWithStyle("Femme", color: Colors.pink),
                            new Switch(
                                value: sexe,
                                inactiveTrackColor: Colors.pink,
                                activeTrackColor: Colors.blue,
                                onChanged: (bool b) {
                                  setState(() {
                                    sexe = b;
                                  });
                                }),
                            gentextWithStyle("Homme", color: Colors.blue)
                          ],
                        ),
                        padding(),
                        // Date de naissance
                        new RaisedButton(
                            color: setColor(),
                            child: gentextWithStyle(
                                (yearOld == null)
                                    ? "Appuyer pour rentrer votre âge"
                                    : "Votre age est de : ${yearOld.toInt()} ans",
                                color: Colors.white),
                            onPressed: (() => showPicker())),
                        // Slider pour la gestion de la taille
                        padding(),
                        gentextWithStyle(
                            "Votre taille est de : ${size.toInt()} cm",
                            color: setColor()),
                        padding(),
                        new Slider(
                          value: size,
                          activeColor: setColor(),
                          onChanged: (double d) {
                            setState(() {
                              size = d;
                            });
                          },
                          max: 215.0,
                          min: 100.0,
                        ),
                        padding(),
                        // Champs poids
                        new TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (String string) {
                            setState(() {
                              weight = double.tryParse(string);
                            });
                          },
                          decoration: new InputDecoration(
                              labelText: "Entrez votre poids en kilos."),
                        ),
                        padding(),
                        gentextWithStyle("Quelle est votre activité sportive?",
                            color: setColor()),
                        padding(),
                        rowRadio(),
                        padding()
                      ],
                    ),
                  ),
                  padding(),
                  new RaisedButton(
                    color: setColor(),
                    child: gentextWithStyle("Calculer", color: Colors.white),
                    onPressed: calculNbrCalories,
                  )
                ],
              ))),
    );
  }

  Padding padding() {
    return new Padding(padding: EdgeInsets.only(top: 20.0));
  }

  Future<Null> showPicker() async {
    DateTime choice = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now(),
        initialDatePickerMode: DatePickerMode.year);
    if (choice != null) {
      var difference = new DateTime.now().difference(choice);
      var day = difference.inDays;
      var year = (day / 365);
      setState(() {
        yearOld = year;
      });
    }
  }

  // permet de set la couleur de l'UI selon le choix de l'utilisateur
  Color setColor() {
    if (sexe) {
      return Colors.blue;
    } else {
      return Colors.pink;
    }
  }

  // Permet d'uniformiser tous les champs textes
  Text gentextWithStyle(String data, {color: Colors.black, fontSize: 15.0}) {
    return new Text(data,
        textAlign: TextAlign.center,
        style: new TextStyle(color: color, fontSize: fontSize));
  }

  // Permet de générer les boutons radios
  Row rowRadio() {
    List<Widget> l = [];
    mapActivite.forEach((key, value) {
      Column column = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
              activeColor: setColor(),
              value: key,
              groupValue: radioSelector,
              onChanged: (Object i) {
                setState(() {
                  radioSelector = i;
                });
              }),
          gentextWithStyle(value, color: setColor())
        ],
      );
      l.add(column);
    });
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,
    );
  }

  void calculNbrCalories() {
    if (yearOld != null && weight != null && radioSelector != null) {
      //Calculer
      if (sexe) {
        calorieBase = (66.4730 +
                (13.7516 * weight) +
                (5.0033 * size) -
                (6.7550 * yearOld))
            .toInt();
      } else {
        calorieBase = (655.0955 +
                (9.5634 * weight) +
                (1.8496 * size) -
                (4.6756 * yearOld))
            .toInt();
      }
      switch (radioSelector) {
        case 0:
          calorieActivite = (calorieBase * 1.2).toInt();
          break;
        case 1:
          calorieActivite = (calorieBase * 1.5).toInt();
          break;
        case 2:
          calorieActivite = (calorieBase * 1.8).toInt();
          break;
        default:
          calorieActivite = calorieBase;
          break;
      }

      setState(() {
        dialogue();
      });
    } else {
      alerte();
    }
  }

  Future<Null> alerte() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return new AlertDialog(
            title: gentextWithStyle("Erreur"),
            content: gentextWithStyle("Tous les champs ne sont pas remplis"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(buildContext);
                  },
                  child: gentextWithStyle("OK", color: Colors.red))
            ],
          );
        });
  }

  Future<Null> dialogue() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return SimpleDialog(
            title:
                gentextWithStyle("Votre besoin en calories", color: setColor()),
            contentPadding: EdgeInsets.all(15.0),
            children: <Widget>[
              padding(),
              gentextWithStyle("Votre besoin de base est de: $calorieBase"),
              padding(),
              gentextWithStyle(
                  "Votre besoin avec activité sportive est de : $calorieActivite"),
              new RaisedButton(
                onPressed: () {
                  Navigator.pop(buildContext);
                },
                child: gentextWithStyle("OK", color: Colors.white),
                color: setColor(),
              )
            ],
          );
        });
  }
}

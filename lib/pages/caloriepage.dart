import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      // Permet de masquer le bandeau debug
      debugShowCheckedModeBanner: false,
      title: 'Calorilator',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Calorilator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int calorieBase;
  int calorieActivite;
  int sportingFrenquency;
  double weight;
  double yearOld;
  double size = 170.0;
  bool sexe = false;
  Map mapSportingFrenquency = {
    "Faible": 0,
    "Modere": 1,
    "Forte": 2,
  };

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      // permet de quitter le clavier en cliquant en sur l'écran (abs de btn retour sur IOS)
      onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
      child: new Scaffold(
          appBar: new AppBar(
            title: new Text(widget.title),
            backgroundColor: setColor(),
          ),
          body: new SingleChildScrollView(
              padding: EdgeInsets.all(15.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  genTextStyle(
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
                            genTextStyle("Femme", color: Colors.pink),
                            new Switch(
                                value: sexe,
                                inactiveTrackColor: Colors.pink,
                                activeTrackColor: Colors.blue,
                                onChanged: (bool b) {
                                  setState(() {
                                    sexe = b;
                                  });
                                }),
                            genTextStyle("Homme", color: Colors.blue)
                          ],
                        ),
                        padding(),
                        // Date de naissance
                        new RaisedButton(
                            color: setColor(),
                            child: genTextStyle(
                                (yearOld == null)
                                    ? "Appuyer pour rentrer votre"
                                    : "Votre age est de : ${yearOld.toInt()} ans",
                                color: Colors.white),
                            onPressed: (() => showPicker())),
                        // Slider pour la gestion de la taille
                        padding(),
                        genTextStyle("Votre taille est de : ${size.toInt()} cm",
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
                        genTextStyle("Quelle est votre activité sportive?",
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
                    child: genTextStyle("Calculer", color: Colors.white),
                    onPressed: calculNbrCaloris,
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
  Text genTextStyle(String data, {color: Colors.black, fontSize: 15.0}) {
    return new Text(data,
        textAlign: TextAlign.center,
        style: new TextStyle(color: color, fontSize: fontSize));
  }


  // génération des boutons radios
  Row rowRadio() {
    List<Widget> l = [];
    mapSportingFrenquency.forEach((key, value) {
      Column column = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
              activeColor: setColor(),
              value: key,
              groupValue: sportingFrenquency,
              onChanged: (Object i) {
                setState(() {
                  sportingFrenquency = i;
                });
              }),
          genTextStyle(value, color: setColor())
        ],
      );
      l.add(column);
    });
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,
    );
  }



  void calculNbrCaloris() {
    if (yearOld != null && weight != null && sportingFrenquency != null) {
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
      switch (sportingFrenquency) {
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
            title: genTextStyle("Erreur"),
            content: genTextStyle("Tous les champs ne sont pas remplis"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(buildContext);
                  },
                  child: genTextStyle("OK", color: Colors.red))
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
            title: genTextStyle("Votre besoin en calories", color: setColor()),
            contentPadding: EdgeInsets.all(15.0),
            children: <Widget>[
              padding(),
              genTextStyle("Votre besoin de base est de: $calorieBase"),
              padding(),
              genTextStyle(
                  "Votre besoin avec activité sportive est de : $calorieActivite"),
              new RaisedButton(
                onPressed: () {
                  Navigator.pop(buildContext);
                },
                child: genTextStyle("OK", color: Colors.white),
                color: setColor(),
              )
            ],
          );
        });
  }
}

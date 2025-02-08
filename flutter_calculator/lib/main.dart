import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'calc_button.dart'; // Import du fichier contenant le widget CalcButton

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoDev05 Calculator',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 0, 0)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String memory = "";
  List<String> operators = ["÷", "x", "-", "+", "="];
  String currentCalcul = "0";
  List<String> tableCalcul = ["0"];

  bool isPossibleToAddComma = true;

  void resetMemory() {
    setState(() {
      memory = "";
    });
  }

  void buildStringCalcul() {
    String newCalcul = "";

    for (String value in tableCalcul) {
      newCalcul = newCalcul + value;
    }
    setState(() {
      currentCalcul = newCalcul;
      memory = "";
    });
  }

  void resetAll() {
    isPossibleToAddComma = true;
    resetMemory();
    tableCalcul = [];
    tableCalcul.add("0");
    buildStringCalcul();
  }

  bool isOperator(String value) {
    return operators.contains(value);
  }

  bool lastIsOperator() {
    return isOperator(tableCalcul.last);
  }

  void addValue(String value) {
    String lastValue = tableCalcul.last[tableCalcul.last.length - 1];
    bool valueIsNewOne = lastIsOperator();
    bool isFirst = tableCalcul.last.length == 1 && tableCalcul.length == 1;

    if (tableCalcul.length == 1 &&
        isFirst &&
        lastValue == "0" &&
        value == "-") {
      tableCalcul.last = value;
    } else if (isOperator(value)) {
      if (valueIsNewOne) {
        if (value == "-" && lastValue != "-") {
          tableCalcul.add(value);
        } else if (value != "-" &&
            lastValue == "-" &&
            isOperator(tableCalcul[tableCalcul.length - 2])) {
          tableCalcul.removeAt(tableCalcul.length - 1);
          tableCalcul.last = value;
        } else {
          tableCalcul.last = value;
        }
      } else {
        tableCalcul.add(value);
      }
      isPossibleToAddComma = true;
    } else {
      if (tableCalcul.length == 1 &&
          isFirst &&
          lastValue == "0" &&
          value != "," &&
          value != "%") {
        tableCalcul.last = value;
      } else if (value == "0") {
        if (valueIsNewOne) {
          tableCalcul.add(value);
        } else {
          tableCalcul.last = tableCalcul.last + value;
        }
      } else if (value == ",") {
        if (!isPossibleToAddComma || lastIsOperator()) {
        } else if (valueIsNewOne && !isFirst) {
          tableCalcul.add(value);
          isPossibleToAddComma = false;
        } else {
          tableCalcul.last = tableCalcul.last + value;
          isPossibleToAddComma = false;
        }
      } else if (value == "%") {
        if (valueIsNewOne) {
          tableCalcul.last = value;
        } else if (isFirst) {
          tableCalcul.add(value);
        } else if (lastValue == "%") {
          int idx = tableCalcul.indexOf("%");
          if (idx + 2 < tableCalcul.length &&
              tableCalcul[idx + 1] != ")" &&
              tableCalcul[idx + 2] == "%") {
          } else {
            if (idx == -1) {
              tableCalcul.insert(tableCalcul.length - 2, "(");
            } else {
              tableCalcul.insert(idx - 1, "(");
            }
            // Chercher l'indice de ou mettre la parenthèse
            tableCalcul.add(")");
            tableCalcul.add(value);
          }
        } else {
          tableCalcul.add(value);
        }
      } else {
        if (tableCalcul.length == 1 && lastValue == "0") {
          tableCalcul.last = value;
        } else if (valueIsNewOne || tableCalcul.last == "%") {
          tableCalcul.add(value);
        } else {
          tableCalcul.last = tableCalcul.last + value;
        }
      }
    }

    buildStringCalcul();

    setState(() {
      memory = "";
    });
  }

  void deleteLeft() {
    if (tableCalcul.last == "%") {
      int idx = tableCalcul.indexOf("(");
      if (idx != -1) {
        tableCalcul.removeAt(idx);
        tableCalcul.removeAt(tableCalcul.length - 1);
      }
      tableCalcul.removeAt(tableCalcul.length - 1);
    } else if (isOperator(tableCalcul.last)) {
      tableCalcul.removeAt(tableCalcul.length - 1);
    } else if (tableCalcul.length == 1 && tableCalcul.last.length == 1) {
      tableCalcul.last = "0";
    } else {
      if (tableCalcul.last[tableCalcul.last.length - 1] == ",") {
        isPossibleToAddComma = true;
      }
      tableCalcul.last =
          tableCalcul.last.substring(0, tableCalcul.last.length - 1);

      if (tableCalcul.last.isEmpty) {
        tableCalcul.removeAt(tableCalcul.length - 1);
      }
    }
    buildStringCalcul();
  }

  void calculTheResult() {
    String resultat = "";
    bool impossibleToCalcul = tableCalcul.length == 1 ||
        (tableCalcul.length == 2 &&
            (isOperator(tableCalcul.last) && tableCalcul.last != "%")) ||
        (tableCalcul.length == 2 &&
            (tableCalcul[0] == "-" && tableCalcul.last != "%")) ||
        (tableCalcul.length == 3 &&
            tableCalcul[0] == "-" &&
            isOperator(tableCalcul[2])) ||
        (tableCalcul.last == "-" &&
            isOperator(tableCalcul[tableCalcul.length - 2]));

    // Si il y'a un opérateur à la fin (mais pas une seule valeur) alors on l'ignore. Ainsi '2 + 2 +' devient '2 + 2'
    if (!impossibleToCalcul) {
      resultat = currentCalcul;

      if (isOperator(tableCalcul.last)) {
        tableCalcul.removeAt(tableCalcul.length - 1);
      }

      tableCalcul = tableCalcul.map((val) => val.replaceAll(",", ".")).toList();

      if (tableCalcul[0] == "-") {
        tableCalcul[0] = tableCalcul[0] + tableCalcul[1];
        tableCalcul.removeAt(1);
      }

      for (int i = 0; i < tableCalcul.length - 1; i++) {
        if (i < tableCalcul.length && tableCalcul[i] == "-") {
          if (i - 1 >= 0 && isOperator(tableCalcul[i - 1])) {
            tableCalcul[i] = tableCalcul[i] + tableCalcul[i + 1];
            tableCalcul.removeAt(i + 1);
          }
        }
      }

      // The first is all the %
      while ((tableCalcul.contains("%"))) {
        int idx = tableCalcul.indexOf("%");

        if (idx + 1 < tableCalcul.length) {
          if (!isOperator(tableCalcul[idx + 1]) &&
              tableCalcul[idx + 1] != ")") {
            tableCalcul[idx - 1] = (double.parse(tableCalcul[idx - 1]) %
                    double.parse(tableCalcul[idx + 1]))
                .toString();
            tableCalcul.removeAt(idx);
            tableCalcul.removeAt(idx);
          } else {
            tableCalcul[idx - 1] =
                (double.parse(tableCalcul[idx - 1]) / 100).toString();
            tableCalcul.removeAt(idx);
            if (tableCalcul[idx] == ")") {
              tableCalcul.removeAt(idx);
              tableCalcul.removeAt(idx - 2);
            }
          }
        } else {
          // The % is in last position
          tableCalcul[idx - 1] =
              (double.parse(tableCalcul[idx - 1]) / 100).toString();
          tableCalcul.removeAt(idx);
        }
      }

      while (tableCalcul.contains("x")) {
        int idx = tableCalcul.indexOf("x");

        tableCalcul[idx - 1] = (double.parse(tableCalcul[idx - 1]) *
                double.parse(tableCalcul[idx + 1]))
            .toString();
        tableCalcul.removeAt(idx);
        tableCalcul.removeAt(idx);
      }

      while (tableCalcul.contains("÷")) {
        int idx = tableCalcul.indexOf("÷");

        tableCalcul[idx - 1] = (double.parse(tableCalcul[idx - 1]) /
                double.parse(tableCalcul[idx + 1]))
            .toString();
        tableCalcul.removeAt(idx);
        tableCalcul.removeAt(idx);
      }

      if (tableCalcul.contains("-") || tableCalcul.contains("+")) {
        double somme = 0;
        String operateur = "+"; // Commence par une addition par défaut

        for (String element in tableCalcul) {
          if (element == "+" || element == "-") {
            operateur = element; // Met à jour l'opérateur
          } else {
            double valeur = double.parse(element);
            if (operateur == "+") {
              somme += valeur;
            } else {
              somme -= valeur;
            }
          }
        }
        tableCalcul = [somme.toString()];
      }

      tableCalcul[0] = double.parse(tableCalcul[0]) % 1 == 0
          ? double.parse(tableCalcul[0]).toInt().toString()
          : double.parse(tableCalcul[0]).toString();
      tableCalcul = tableCalcul.map((val) => val.replaceAll(".", ",")).toList();

      buildStringCalcul();
      setState(() {
        memory = resultat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Liste des lignes avec leurs boutons
    final List<List<Map<String, dynamic>>> buttonRows = [
      [
        {'text': 'AC', 'value': 'AC', 'color': const Color.fromARGB(255, 120, 119, 119)},
        {'icon': FontAwesomeIcons.deleteLeft, 'value': 'deleteLeft', 'color': const Color.fromARGB(255, 120, 119, 119)},
        {'icon': FontAwesomeIcons.percent, 'value': '%', 'color': const Color.fromARGB(255, 120, 119, 119)},
        {'icon': FontAwesomeIcons.divide, 'value': '÷', 'color': Colors.blue},
      ],
      [
        {'icon': FontAwesomeIcons.seven, 'value': '7'},
        {'icon': FontAwesomeIcons.eight, 'value': '8'},
        {'icon': FontAwesomeIcons.nine, 'value': '9'},
        {'icon': FontAwesomeIcons.xmark, 'value': 'x', 'color': Colors.blue},
      ],
      [
        {'icon': FontAwesomeIcons.four, 'value': '4'},
        {'icon': FontAwesomeIcons.five, 'value': '5'},
        {'icon': FontAwesomeIcons.six, 'value': '6'},
        {'icon': FontAwesomeIcons.minus, 'value': '-', 'color': Colors.blue},
      ],
      [
        {'icon': FontAwesomeIcons.one, 'value': '7'},
        {'icon': FontAwesomeIcons.two, 'value': '8'},
        {'icon': FontAwesomeIcons.three, 'value': '9'},
        {'icon': FontAwesomeIcons.plus, 'value': '+', 'color': Colors.blue},
      ],
      [
        {'icon': FontAwesomeIcons.zero, 'value': '0', 'width': 174.0},
        {'text': ',', 'value': ',', 'color': Colors.blue},
        {'icon': FontAwesomeIcons.equals, 'value': '=', 'color': Colors.blue},
      ],
    ];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              widget.title,
              style: TextStyle(color: Colors.white),
            ),
          )),
      body: Center(
          child: Column(
        children: [
          Spacer(),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse:
                      true, // Permet au texte de s'aligner à droite et défiler vers la gauche
                  child: Text(
                    memory,
                    style: TextStyle(
                        color: const Color.fromARGB(255, 120, 119, 119),
                        fontSize: 28),
                  ),
                ),
              ),
              SizedBox(width: 27),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse:
                      true, // Permet au texte de s'aligner à droite et défiler vers la gauche
                  child: Text(
                    currentCalcul,
                    style: TextStyle(color: Colors.white, fontSize: 54),
                  ),
                ),
              ),
              SizedBox(width: 27),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ...buttonRows.map((row) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(width: 7.0), // Espace à gauche
                    ...row.map((btn) => CalcButton(
                          onPressed: () => btn['value'] == 'AC'
                              ? resetAll()
                              : btn['value'] == 'deleteLeft'
                                  ? deleteLeft()
                                  : btn['value'] == '='
                                      ? calculTheResult()
                                      : addValue(btn['value']),
                          icon: btn.containsKey('icon') ? btn['icon'] : null,
                          text: btn.containsKey('text') ? btn['text'] : null,
                          color: btn['color'] ??
                              const Color.fromARGB(255, 50, 50, 50),
                          width: btn.containsKey('width') ? btn['width'] : null,
                        )),
                    const SizedBox(width: 7.0), // Espace à droite
                  ],
                ),
                const SizedBox(
                    height: 10.0), // Espace vertical entre les lignes
              ],
            );
          }),
          SizedBox(height: 45.00),
        ],
      )),
      backgroundColor: Colors.black,
    );
  }
}

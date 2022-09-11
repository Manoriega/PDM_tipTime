import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO: completar todo lo necesario
  bool roundUp = false;
  double amount = 0;
  int? currentRadio = 0;
  var priceController = TextEditingController(),
      radioGroup = {0: "Amazing (20%)", 1: "Good (18%)", 2: "Okay (15%)"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(76, 175, 80, 1),
          title: Text('Tip time'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: [
            SizedBox(height: 14),
            ListTile(
              leading: Icon(Icons.store, color: Color.fromRGBO(76, 175, 80, 1)),
              title: Padding(
                padding: EdgeInsets.only(right: 24),
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      try {
                        final text = newValue.text;
                        if (text.isNotEmpty) double.parse(text);
                        return newValue;
                      } catch (e) {}
                      return oldValue;
                    }),
                  ],
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelStyle:
                        TextStyle(color: Color.fromRGBO(76, 175, 80, 1)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(76, 175, 80, 1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Color.fromRGBO(76, 175, 80, 1))),
                    labelText: "Cost of service",
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.room_service,
                color: Color.fromRGBO(76, 175, 80, 1),
              ),
              title: Text("How was the service?"),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: radioGroupGenerator(),
            ),
            ListTile(
              leading: Icon(
                Icons.call_made,
                color: Color.fromRGBO(76, 175, 80, 1),
              ),
              title: Text("Round up tip?"),
              trailing: Switch(
                activeColor: Color.fromRGBO(76, 175, 80, 1),
                value: roundUp,
                onChanged: (value) {
                  setState(() {
                    roundUp = value;
                  });
                  print(roundUp);
                },
              ),
            ),
            MaterialButton(
              child: Text("CALCULATE", style: TextStyle(color: Colors.white)),
              color: Color.fromRGBO(76, 175, 80, 1),
              onPressed: _tipCalculation,
            ),
            Text("Tip amount: \$${amount.toStringAsFixed(2)}"),
          ]),
        ));
  }

  void _tipCalculation() {
    if (priceController.text == "" ||
        priceController.text.contains("[a-zA-Z]+") == true) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Advertencia'),
                content: const Text('No se ingreso ninguna cantidad válida'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Ok'),
                    child: const Text('Ok'),
                  ),
                ],
              ));
    } else {
      amount = double.parse(priceController.text);
      switch (currentRadio) {
        case 0:
          amount *= 0.2;
          break;
        case 1:
          amount *= 0.18;
          break;
        case 2:
          amount *= 0.15;
          break;
      }
      print(amount);
      if (roundUp == true) {
        amount = amount.roundToDouble();
        print(amount);
      }
    }
    setState(() {});
  }

  radioGroupGenerator() {
    return radioGroup.entries
        .map((radioElement) => ListTile(
              leading: Radio(
                activeColor: Color.fromRGBO(76, 175, 80, 1),
                value: radioElement.key,
                groupValue: currentRadio,
                onChanged: (int? selected) {
                  currentRadio = selected;
                  setState(() {});
                },
              ),
              title: Text("${radioElement.value}"),
            ))
        .toList();
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'oh_items.dart';
import 'oh_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'House Control',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Hügelstraße 14'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const ohTextStyle = TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500);
  static const ohTitleStyle = TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600, fontSize: 30.0);

  List<Future<OHSwitch>> ohSwitch = [];
  List<Future<OHString>> ohString = [];
  OHConfig ohConfig = getConfiguration();

  @override
  void initState() {
    super.initState();
    for (int i=0; i<ohConfig.listOfSwitches.length; i++) {
      ohSwitch.add(fetchSwitch(ohConfig.listOfSwitches[i]));
    }
    for (int i=0; i<ohConfig.listOfStrings.length; i++) {
      ohString.add(fetchString(ohConfig.listOfStrings[i]));
    }
  }

  Future<OHString> fetchString(String itemName) async {
    final response = await http.get(Uri.parse(ohConfig.itemUrl(itemName)));
    if (response.statusCode == 200) {
      return OHString.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load switch');
    }
  }

  List<Widget> stringWidgets() {
    List<FutureBuilder> widgets = [];
    for (int i=0; i<ohString.length; i++) {
      widgets.add(
        FutureBuilder<OHString>(
          future: ohString[i],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return
                Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(160),
                    1: IntrinsicColumnWidth(),
                    2: FixedColumnWidth(64),
                  },
                  children: [
                  TableRow(children: [
                    TableCell(child: Text((snapshot.data as OHString).label+' ', style: ohTextStyle)),
                    TableCell(child: Text(double.parse((snapshot.data as OHString).state).toStringAsFixed(2), style: ohTextStyle)),
                    TableCell(child: Text(' '+ohConfig.listOfSuffixes[i], style: ohTextStyle)),
                  ]),
                ]);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      );
    }  
    return widgets;
  }

  List<Widget> switchWidgets() {
    List<FutureBuilder> widgets = [];
    for (int i=0; i<ohSwitch.length; i++) {
      widgets.add(
        FutureBuilder<OHSwitch>(
          future: ohSwitch[i],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Text((snapshot.data as OHSwitch).label, style: ohTextStyle),
                  Switch(value: (snapshot.data as OHSwitch).state,
                          onChanged: (x) {setSwitch(ohConfig.listOfSwitches[i],x);
                                          setState(() {(snapshot.data as OHSwitch).state = x;});
                                        },
                          inactiveTrackColor: Colors.red,
                          inactiveThumbColor: Colors.white,
                          activeTrackColor: Colors.green,
                          activeColor: Colors.white,
                          ),
                  ]); 
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      );
    }  
    return widgets;
  }

  List<Widget> displayWidgets() {
    List<Widget> stringW = stringWidgets();
    List<Widget> switchW = switchWidgets();
    return stringW+switchW;
  }

  Future<OHSwitch> fetchSwitch(String itemName) async {
    final response = await http.get(Uri.parse(ohConfig.itemUrl(itemName)));
    if (response.statusCode == 200) {
      return OHSwitch.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load switch');
    }
  }

  void setSwitch(String itemName, bool newState) async {
    final response = await http.post(Uri.parse(ohConfig.itemUrl(itemName)),body: (newState ? 'ON' : 'OFF'), headers: {"Content-Type": "text/plain"});
    if (response.statusCode != 200) {
      throw Exception('Error setting state');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Container(
            padding: EdgeInsets.fromLTRB(40, 40, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Container(padding: EdgeInsets.fromLTRB(0, 0, 0, 20), child: Text('Outdoors', style: ohTitleStyle))]+displayWidgets(),
            )),
    );    
  }
}

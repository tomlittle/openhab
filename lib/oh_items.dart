import 'package:flutter/material.dart';

class OHString {
  final String label;
  final String name;
  String state;

  OHString({
    required this.label,
    required this.name,
    required this.state,
  });

  factory OHString.fromJson(Map<String, dynamic> json) {
    return OHString(
      label: json['label'],
      name:  json['name'],
      state: json['state'],
    );
  }
}

class OHSwitch {
  final String label;
  final String name;
  bool   state;
  String value;
  Switch uiSwitch;

  OHSwitch({
    required this.label,
    required this.name,
    required this.state,
    required this.value,
    required this.uiSwitch,
  });

  factory OHSwitch.fromJson(Map<String, dynamic> json) {
    return OHSwitch(
      label: json['label'],
      name:  json['name'],
      state: json['state']=='ON',
      value: (json['state']=='ON' ? '100,100,100' : '0,0,0'),
      uiSwitch: const Switch(value: false, onChanged: null)
    );
  }
}

class OHColorLight {
  final String label;
  final String name;
  final bool   state;
  final bool   value;

  OHColorLight({
    required this.label,
    required this.name,
    required this.state,
    required this.value,
  });

  factory OHColorLight.fromJson(Map<String, dynamic> json) {
    return OHColorLight(
      label: json['label'],
      name: json['name'],
      state: json['state']=='ON', // !!!
      value: true, // !!!
    );
  }  
}

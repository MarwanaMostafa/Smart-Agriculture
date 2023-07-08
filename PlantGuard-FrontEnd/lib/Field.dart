import 'package:flutter/material.dart';

class Field {
  final int fieldId;
  final String plant;
  final int size;
  final String address;

  static Field _currentField;

  Field({
    @required this.fieldId,
    @required this.plant,
    @required this.size,
    @required this.address,
  });

  static void setField(Field field){
    _currentField = field;
  }

  static Field getCurrentField() {
    return _currentField;
  }

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      fieldId: json['field_id'],
      plant: json['plant'],
      size: json['size'],
      address: json['address'],
    );
  }
}

import 'package:flutter/material.dart';

class Fx {
  int _id;
  String _name;
  double _percent;
  double _value;
  String _comment;
  int _type;
  List<Fx> _children = [];

  Fx(this._id, this._name, this._value, this._percent, this._type, this._comment);

  int get id => this._id;
  int get type => this._type;
  String get name => this._name;
  String get comment => this._comment;
  double get value => this._value;
  double get percent => this._percent;
  List<Fx> get children => this._children;

  set value(double value){
    this._value = value;
  }

  set comment(String comment){
    this._comment = comment;
  }

  void addChild(Fx child) {
    _children.add(child);
  }

  void addChildren(List<Fx> children) {
    _children.addAll(children);
  }

  @override
  String toString() {
    return "{id: $_id, name: $_name, value: $_value}";
  }

  getChildrenLabel(){
    return "children";
  }

  void printFx() {
    var hasChildren = children.isNotEmpty;
    print('{');
    print('    "id": ${id},');
    print('    "name": "${name}",');
    print('    "weight": "${percent}",');
    print('    "value": ${value}' + (hasChildren ? ',' : '}'));
    if (hasChildren) {
      print('"${getChildrenLabel()}": [');
      children.forEach((element) {
        element.printFx();
        print(',');
      });
      print(']}');
    }
  }

  toList(){
    List<Fx> list = [this];
    if(this.children.isNotEmpty) {
      this.children.forEach((element) {
        list.addAll(element.toList());
      });
    }
    return list;
  }

  computeValue(){
    var total = .0;
    if(this.children.isNotEmpty) {
      this.children.forEach((element) {
        total += element.value * (element.percent / 100);
      });
      this.value = total;
    }
  }
}
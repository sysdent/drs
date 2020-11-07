import 'package:perforaya/model/fx/fx.dart';

class RequirementFx extends Fx{

  RequirementFx(int id, String name, double percent, String comment) : super(id, name, 0, percent, 6, comment);

  void setValue(double value){
    this.value = value;
  }
}
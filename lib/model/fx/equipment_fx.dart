import 'package:perforaya/model/fx/fx.dart';
import 'package:perforaya/model/fx/specification_fx.dart';

class EquipmentFx extends Fx{

  EquipmentFx(int id, String name, double percent, String comment) : super(id, name, 0, percent, 4, comment);

  List<SpecificationFx> get specifications => this.children;

  @override
  getChildrenLabel() {
    return "specifications";
  }

}
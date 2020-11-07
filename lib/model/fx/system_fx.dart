import 'package:perforaya/model/fx/equipment_fx.dart';
import 'package:perforaya/model/fx/fx.dart';

class SystemFx extends Fx{

  SystemFx(int id, String name, double percent, String comment) : super(id, name, 0, percent, 3, comment);

  List<EquipmentFx> get equipments => this.children;

  @override
  getChildrenLabel() {
    return "equipments";
  }

}
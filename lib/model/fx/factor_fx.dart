import 'package:perforaya/model/fx/fx.dart';
import 'package:perforaya/model/fx/system_fx.dart';

class FactorFx extends Fx{

  FactorFx(int id, String name, double percent, String comment) : super(id, name, 0, percent, 2, comment);

  List<SystemFx> get systems => this.children;

  @override
  getChildrenLabel() {
    return "systems";
  }

}
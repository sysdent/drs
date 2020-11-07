import 'package:perforaya/model/fx/fx.dart';
import 'package:perforaya/model/fx/system_fx.dart';

class OfferFx extends Fx{

  OfferFx(int id, String name, double percent, String comment) : super(id, name, 0, percent, 1, comment);

  List<SystemFx> get offers => this.children;

  @override
  getChildrenLabel() {
    return "offers";
  }

}
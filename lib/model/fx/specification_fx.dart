import 'package:perforaya/model/fx/fx.dart';
import 'package:perforaya/model/fx/requirement_fx.dart';

class SpecificationFx extends Fx{

  SpecificationFx(int id, String name, double percent, String comment) : super(id, name, 0, percent, 5, comment);

  List<RequirementFx> get requirements => this.children;

  @override
  getChildrenLabel() {
    return "requirements";
  }

  computeValue(){
    var total = .0;
    if(this.children.isNotEmpty) {
      this.children.forEach((element) {
        total += element.value;
      });
      this.value = total / children.length;
    }
  }

}
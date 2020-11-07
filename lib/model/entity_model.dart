class EntityModel{

  int _id;

  EntityModel(this._id);

  String get name => null;

  set id(int id) {
    this._id = id;
  }

  int get id => this._id;


  bool operator ==(dynamic other) =>
      other != null && other is EntityModel && this.id == other.id;

  @override
  int get hashCode => super.hashCode;
}
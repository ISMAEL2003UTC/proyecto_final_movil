class ProvidersModel {
  int? id;
  String cedulap;
  String nombrep;
  String direccionp;
  String telefonop;
  String correop;
  // Contructor de la clase 
  ProvidersModel({
    this.id,
    required this.cedulap, //truco alt clik sen code
    required this.nombrep,
    required this.direccionp,
    required this.telefonop,
    required this.correop,
  });
  // Convertir de map/jason a clase (SELECT)
  factory ProvidersModel.fromMap(Map<String,dynamic> data){
    return ProvidersModel(
      id:data["id"],
      cedulap:data["cedulap"],
      nombrep:data["nombrep"],
      direccionp:data["direccionp"],
      telefonop:data["telefonop"],
      correop:data["correop"],
    );
  }
  //Convertir de clase a map (INSERT,UPDATE)
  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'cedulap':cedulap,
      'nombrep':nombrep,
      'direccionp':direccionp,
      'telefonop':telefonop,
      'correop':correop,
    };
  }
}


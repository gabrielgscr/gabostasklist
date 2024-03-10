class GenericResponse {
  int responseCode;
  String responseText;
  Object? responseObject;

  GenericResponse(this.responseCode, this.responseText, {this.responseObject});
}

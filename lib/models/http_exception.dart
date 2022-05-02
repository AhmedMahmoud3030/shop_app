class HttpException implements Exception{
  final String massege;
  HttpException(this.massege);

  @override
  String toString() {
    return massege;
    // TODO: implement toString
    //return super.toString();
  }
}
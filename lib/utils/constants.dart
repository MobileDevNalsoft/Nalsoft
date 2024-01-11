class Constants{
  static final regex = RegExp( r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{10,}$');
  static final empIDRegex = RegExp(r'^\d+$');
}
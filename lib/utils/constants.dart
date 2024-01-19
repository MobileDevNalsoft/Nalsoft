class Constants {
  static final regex = RegExp(
      r'(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{":;\' '?/<>,.])');
  static final empIDRegex = RegExp(r'^\d+$');
  static bool empHomeIsLoading = true;
  static bool empSearchIsLoading = true;
}

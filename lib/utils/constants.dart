class Constants {
  static final regex = RegExp(
      r'(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{":;\' '?/<>,.])');
  static final empIDRegex = RegExp(r'^\d+$');
  static bool empSearchIsLoading = true;
  static bool admHomeIsLoading = true;
  static const String BASE_URL1 =
      "https://idcs-ac4ac46e19bc40f29497e733be8f39b2.identity.oraclecloud.com/";
  static const String BASE_URL2 =
      "https://nals-oic-lrx8pchwityh-ld.integration.ocp.oraclecloud.com:443/ic/api/integration/v1/flows/rest";
}

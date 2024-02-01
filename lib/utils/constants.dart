class AppConstants {
  static final regex = RegExp(
      r'(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z])(?=.*[!@#$%^&*()_+}{":;\' '?/<>,.])');
  static final empIDRegex = RegExp(r'^\d+$');
  static bool empSearchIsLoading = true;
  static bool admHomeIsLoading = true;
  static const String BASE_URL1 =
      "https://idcs-7a99f7e141c2455daf8e203757d28727.identity.oraclecloud.com/";
  static const String BASE_URL2 =
      "https://nals-oic-lrx8pchwityh-ld.integration.ocp.oraclecloud.com:443/ic/api/integration/v1/flows/rest";
  static const String AUTHENCTICATE_USER_NAME = "sso/v1/sdk/authenticate";
  static const String GetOCITOKEN = "oauth2/v1/token";
  static const String GETUSERINFO = "/GETUSERINFODATA/1.0/GetUserInfo";
  static const String USERNAME = "username";
  static const String PASSWORD = "password";
  static const String TOKEN = 'token';
  static const String AUTHTOKEN = 'authtoken';
  static const String REQ_STATE = 'requestState';
  static const String APIUSERNAME = 'IntegrationDeveloper';
  static const String APIPASSWORD = 'Nalsoft@123456';
  static const String GETUSEREVENTSDATA = "/GETUSEREVENTSDATA/1.0/GetUserEventData";
}

class AppConstants {
  static final empIDRegex = RegExp(r'^\d+$');
  // static bool empSearchIsLoading = true;
  static bool admHomeIsLoading = true;
  static const String BASE_URL1 =
      "https://idcs-ceca8ff48a7341bebbe31aba04db25b2.identity.oraclecloud.com/";
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
  static const String GETUSEREVENTSDATA =
      "/GETUSEREVENTSDATA/1.0/GetUserEventData";
  static const String UPDATEUSEREVENTS =
      "/UPDATEUSEREVENTS/1.0/UpdateUserEventData";
  static const String DELETEUSEREVENTS =
      "/DELETEUSEREVENTS/1.0/DeleteUserEvnts";
  static const String GETHOLIDAYS = "/GETHOLIDAYS/1.0/GetHolidays";
  static const String GETALLUSERSDATA = "/GETALLUSERDATA/1.0/GetAllUsers";

  static const String SEARCH_DETAILS_API =
      "/SEARCH_DETAILS_API/1.0/GetUserInfo";

  static String PUSH_NOTIFICATIONS_ACCESS_TOKEN = "";
  static late DateTime tokenReceivedTime ;
}

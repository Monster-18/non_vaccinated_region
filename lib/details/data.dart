class Data{
  static bool isUserLoggedIn = false;
  static String user_id = null;

  //Selected village or town
  static String selectedName = "";

  static var json;

  static Map state = {
    'Tamil Nadu': 'TN',
    'Kerala': 'KL',
    'Karnataka': 'KA'
  };
}
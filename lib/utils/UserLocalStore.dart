import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultranote_infinity/model/CurrentUser.dart';

class UserLocalStore {
  late SharedPreferences userLocalDatabase;

  void storeUserData(CurrentUser cUser) async {
    userLocalDatabase = await SharedPreferences.getInstance();
    userLocalDatabase.setString('firstname', cUser.firstName.toString());
    userLocalDatabase.setString('lastname', cUser.lastName.toString());
    userLocalDatabase.setString('email', cUser.email.toString());
    userLocalDatabase.setString('mobile', cUser.mobile.toString());
    userLocalDatabase.setString('otp_auth', cUser.otp.toString());
    userLocalDatabase.setString('twofactorauth', cUser.twoFA.toString());
    userLocalDatabase.setString('isactive', cUser.isActive.toString());
    userLocalDatabase.setString(
        'iswalletcreated', cUser.isWalletCreated.toString());
    userLocalDatabase.setString('currency', cUser.currency.toString());
    userLocalDatabase.setString('id', cUser.id.toString());
    userLocalDatabase.setString('image', cUser.image.toString());
    userLocalDatabase.setString('token', cUser.token.toString());
    userLocalDatabase.setString('pass', cUser.pass.toString());
  }

  void clearUserData() async {
    userLocalDatabase = await SharedPreferences.getInstance();
    userLocalDatabase.clear();
  }

  Future<CurrentUser> getLoggedInUser() async {
    userLocalDatabase = await SharedPreferences.getInstance();
    var firstName = userLocalDatabase.getString('firstname');
    var lastName = userLocalDatabase.getString('lastname');
    var email = userLocalDatabase.getString('email');
    var mobile = userLocalDatabase.getString('mobile');
    var otp = userLocalDatabase.getString('otp_auth');
    var twoFactorAuth = userLocalDatabase.getString('twofactorauth');
    var isActive = userLocalDatabase.getString('isactive');
    var isWalletCreated = userLocalDatabase.getString('iswalletcreated');
    var currency = userLocalDatabase.getString('currency');
    var image = userLocalDatabase.getString('image');
    var id = userLocalDatabase.getString('id');
    var token = userLocalDatabase.getString('token');

    var pass = userLocalDatabase.getString('pass');

    CurrentUser currentUser = new CurrentUser(
        firstName,
        lastName,
        email,
        mobile,
        otp,
        twoFactorAuth,
        isActive,
        isWalletCreated,
        currency,
        id,
        image,
        token,
        pass);
    return currentUser;
  }
}

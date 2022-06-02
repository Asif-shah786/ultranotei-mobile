import 'package:get/get.dart';
import 'package:ultranote_infinity/screen/contacts/contact_list_model.dart';

class ContactController extends GetxController {
  static ContactController get to => Get.find();

  List<ContactListMOdel> allContactList = [];

  getContactList(List<ContactListMOdel> list) {
    // allContactList.clear();
    allContactList = list;
    print('---------------------------------');
    print(list);
    print('==========================');
    print(allContactList.length);
    update();
  }

  clearList() {
    allContactList.clear();
    update();
  }
}

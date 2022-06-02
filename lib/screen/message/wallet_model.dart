// ignore_for_file: public_member_api_docs, sort_constructors_first
class wallletModel {
  String address = '';
  String balance = '';
  String createdAt = '';
  String name = '';
  String updatedAt = '';
  String walletHolder = '';
  String id = '';
  String spendKey = '';
  String viewKey = '';

  wallletModel({
    required this.address,
    required this.balance,
    required this.createdAt,
    required this.name,
    required this.updatedAt,
    required this.walletHolder,
    required this.id,
    required this.spendKey,
    required this.viewKey,
  });
  static List<wallletModel> walletList = [];
}

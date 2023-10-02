import 'package:AstroGuru/model/astromall_category_model.dart';
import 'package:AstroGuru/model/astromall_product_model.dart';
import 'package:AstroGuru/model/user_address_model.dart';
import 'package:AstroGuru/utils/services/api_helper.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:AstroGuru/utils/global.dart' as global;

class AstromallController extends GetxController with GetSingleTickerProviderStateMixin {
  List astroCategory = <AstromallCategoryModel>[];
  List astroProduct = <AstromallProductModel>[];
  List astroProductbyId = <AstromallProductModel>[];
  TabController? tabControllerAstroMall;
  int currentIndexAstroMall = 0;
  String? countryCode;
  String? countryCode2;

  //user address
  List userAddress = <UserAddressModel>[];
  APIHelper apiHelper = APIHelper();

  ScrollController scrollController = ScrollController();
  //add address TextEditing controller
  TextEditingController nameController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController alternatePhoneController = TextEditingController();
  TextEditingController flatNoController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  bool isScrollable = false;
  bool isScrollableNot = true;
  String errorText = "";
  ScrollController astromallCatScrollController = ScrollController();
  int fetchRecord = 20;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  FocusNode namefocus = FocusNode();
  FocusNode phone1focus = FocusNode();
  FocusNode phone2focus = FocusNode();

  ScrollController astromallProductScrollController = ScrollController();
  int startIndexForProduct = 0;
  bool isDataLoadedFroProduct = false;
  bool isAllDataLoadedForProduct = false;
  bool isMoreDataAvailableForProduct = false;
  int? productCatId;

  @override
  void onInit() async {
    tabControllerAstroMall = TabController(length: 3, vsync: this, initialIndex: currentIndexAstroMall);
    _init();
    super.onInit();
  }

  _init() async {
    paginateTask();
  }

  updateScroll(bool value) {
    isScrollable = value;
    update();
  }

  void paginateTask() {
    astromallCatScrollController.addListener(() async {
      isScrollable = true;
      update();
      if (astromallCatScrollController.position.pixels == astromallCatScrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('notify in paginatetask');
        update();
        await getAstromallCategory(true);
      }
    });
    astromallProductScrollController.addListener(() async {
      if (astromallProductScrollController.position.pixels == astromallProductScrollController.position.maxScrollExtent && !isAllDataLoadedForProduct) {
        isMoreDataAvailableForProduct = true;
        print('productCatIdddd $productCatId');
        update();
        if (productCatId != null) {
          await getAstromallProduct(productCatId!, true);
        }
      }
    });
  }

  updateCountryCode(value, int flag) {
    if (flag == 1) {
      countryCode = value.toString();
    } else {
      countryCode2 = value.toString();
    }
    update();
  }

  bool isValidData() {
    if (phoneController.text == "") {
      errorText = "Please Enter Phone no.";
      return false;
    } else if (flatNoController.text == "") {
      errorText = "Please Enter Flate no.";
      return false;
    } else if (localityController.text == "") {
      errorText = "Please Enter Locality";
      return false;
    } else if (cityController.text == "") {
      errorText = "Please Enter City";
      return false;
    } else if (countryController.text == "") {
      errorText = "Please Enter Country";
      return false;
    } else if (pinCodeController.text == "") {
      errorText = "Please Enter Pincode";
      return false;
    } else {
      return true;
    }
  }

  getAstromallCategory(bool isLazyLoading) async {
    try {
      print('getAstromallCategory call');
      startIndex = 0;
      if (astroCategory.isNotEmpty) {
        startIndex = astroCategory.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstromallCategory(startIndex, fetchRecord).then((result) {
            if (result.status == "200") {
              astroCategory.addAll(result.recordList);
              update();
              print('astromall cat list length ${astroCategory.length} ');
              if (result.recordList.length == 0) {
                isMoreDataAvailable = false;
                isAllDataLoaded = true;
              }
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print("Exception in getAstromallCategory:-" + e.toString());
    }
  }

  orderRequest({int? catId, int? prodId, int? addId, double? payAmount, int? gstPercent, String? payMethod, double? totalPayment}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.orderAdd(productCatId: catId, productId: prodId, addressId: addId, gst: gstPercent, paymentMethod: payMethod, amount: payAmount, totalPay: totalPayment).then((result) async {
            if (result.status == "200") {
              await global.splashController.getCurrentUserData();
              global.splashController.currentUser?.walletAmount = global.splashController.currentUser?.walletAmount ?? 0 - (totalPayment ?? 0);
              update();

              global.showToast(
                message: 'Order SuccessFully',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            } else {
              global.showToast(
                message: 'Order not created',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in orderRequest : - ${e.toString()}');
    }
  }

  getAstromallProduct(int id, bool isProductLazyLoading) async {
    try {
      print('getAstromallProduct call');
      startIndexForProduct = 0;
      if (astroProduct.isNotEmpty) {
        startIndexForProduct = astroProduct.length;
      }
      if (!isProductLazyLoading) {
        isDataLoadedFroProduct = false;
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstromallProduct(id, startIndexForProduct, fetchRecord).then((result) {
            if (result.status == "200") {
              astroProduct.addAll(result.recordList);
              update();
              if (result.recordList.length == 0) {
                isMoreDataAvailableForProduct = false;
                isAllDataLoadedForProduct = true;
              }
              print('product length:- ${astroProduct.length} ');
              update();
            } else {
              global.showToast(
                message: '',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getAstromallProduct:-" + e.toString());
    }
  }

  getproductById(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getProductById(id).then((result) {
            if (result.status == "200") {
              print('iddd :- $id');
              astroProductbyId = result.recordList;
              update();
            } else {
              global.showToast(
                message: '',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getproductById:-" + e.toString());
    }
  }

  getUserAddressData(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getUserAddress(id).then((result) {
            if (result.status == "200") {
              userAddress = result.recordList;
              update();
            } else {
              global.showToast(
                message: '',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getUserAddressData:-" + e.toString());
    }
  }

  addAddress(int id) async {
    UserAddressModel userAddressModel = UserAddressModel(
      userId: id,
      name: nameController.text,
      phoneNumber: phoneController.text,
      phoneNumber2: alternatePhoneController.text,
      flatNo: flatNoController.text,
      locality: localityController.text,
      landmark: landmarkController.text,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
      pincode: int.parse(pinCodeController.text),
      countryCode: countryCode,
      alternateCountryCode: countryCode2,
    );
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.addAddress(userAddressModel).then((result) {
            if (result.status == "200") {
              print('success');
              countryCode = "IN";
              countryCode2 = "IN";
              update();
            } else {
              global.showToast(
                message: 'Address not added please try later!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in addAddress ${e.toString()}');
    }
  }

  removeData() {
    try {
      nameController.text = "";
      phoneController.text = "";
      alternatePhoneController.text = "";
      flatNoController.text = "";
      localityController.text = "";
      landmarkController.text = "";
      cityController.text = "";
      stateController.text = "";
      countryController.text = "";
      pinCodeController.text = "";
      countryCode = "IN";
      countryCode2 = "IN";
      update();
    } catch (e) {
      print("exception in removeData " + e.toString());
    }
  }

  getEditAddress(int index) async {
    try {
      nameController.text = userAddress[index].name;
      phoneController.text = userAddress[index].phoneNumber;
      alternatePhoneController.text = userAddress[index].phoneNumber2;
      flatNoController.text = userAddress[index].flatNo;
      localityController.text = userAddress[index].locality;
      landmarkController.text = userAddress[index].landmark;
      cityController.text = userAddress[index].city;
      stateController.text = userAddress[index].state;
      countryController.text = userAddress[index].country;
      pinCodeController.text = userAddress[index].pincode.toString();
      countryCode = userAddress[index].countryCode;
      countryCode2 = userAddress[index].alternateCountryCode;
      update();
    } catch (e) {
      print("exception in getEditAddress " + e.toString());
    }
  }

  updateUserAddress(int id) async {
    UserAddressModel userAddressModel = UserAddressModel(
      userId: global.sp!.getInt("currentUserId") ?? 0,
      name: nameController.text,
      phoneNumber: phoneController.text,
      phoneNumber2: alternatePhoneController.text,
      flatNo: flatNoController.text,
      locality: localityController.text,
      landmark: landmarkController.text,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
      pincode: int.parse(pinCodeController.text),
      countryCode: countryCode,
      alternateCountryCode: countryCode2,
    );
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.updateAddress(id, userAddressModel).then((result) {
          if (result.status == "200") {
            global.showToast(
              message: 'Your address have been updated',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          } else {
            global.showToast(
              message: '',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }
}

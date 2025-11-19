import 'package:client/core/utils/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Pallete.greenColor,
    textColor: Pallete.whiteColor,
    fontSize: 16.0,
  );
}

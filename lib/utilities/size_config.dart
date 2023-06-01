import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late double titleFontSize;
  static late double textFontSize;
  static late double smallTextFontSize;
  static late double iconSize;
  static late double iconSizeSmall;
  static late double btnHeight;
  static late double padding;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
    titleFontSize = SizeConfig.safeBlockHorizontal * 4.5;
    textFontSize = SizeConfig.safeBlockHorizontal * 3.25;
    smallTextFontSize = SizeConfig.safeBlockHorizontal * 2.25;
    iconSize = SizeConfig.safeBlockHorizontal * 6;
    iconSizeSmall = SizeConfig.safeBlockHorizontal * 4;
    btnHeight = SizeConfig.safeBlockHorizontal * 10;
    padding = SizeConfig.safeBlockHorizontal * 4;
  }
}

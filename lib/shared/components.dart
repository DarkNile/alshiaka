import 'dart:math';
import 'dart:ui' as ui;
import 'package:ahshiaka/models/categories/products_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:lottie/lottie.dart';
import '../utilities/app_ui.dart';
import '../utilities/app_util.dart';
import '../view/layout/bottom_nav_screen/tabs/categories/products/product_details_screen.dart';

class GradientCircularProgressIndicator extends StatelessWidget {
  final double? radius;
  final List<Color>? gradientColors;
  final double strokeWidth;

  const GradientCircularProgressIndicator({
    Key? key,
    @required this.radius,
    @required this.gradientColors,
    this.strokeWidth = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(radius!),
      painter: GradientCircularProgressPainter(
        radius: radius!,
        gradientColors: gradientColors!,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  GradientCircularProgressPainter({
    @required this.radius,
    @required this.gradientColors,
    @required this.strokeWidth,
  });

  final double? radius;
  final List<Color>? gradientColors;
  final double? strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    size = Size.fromRadius(radius!);
    double offset = strokeWidth! / 2;
    Rect rect = Offset(offset, offset) &
        Size(size.width - strokeWidth!, size.height - strokeWidth!);
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth!;
    paint.shader = SweepGradient(
            colors: gradientColors!, startAngle: 0.0, endAngle: 2 * pi)
        .createShader(rect);
    canvas.drawArc(rect, 0.0, 2 * pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

AppBar customAppBar(
    {required title,
    Widget? leading,
    List<Widget>? actions,
    int elevation = 3,
    Widget? bottomChild,
    Color? backgroundColor,
    bottomChildHeight,
    leadingWidth,
    toolbarHeight}) {
  return AppBar(
    backgroundColor: backgroundColor ?? AppUI.whiteColor,
    elevation: double.parse(elevation.toString()),
    toolbarHeight: toolbarHeight,
    title: title is Widget
        ? title
        : CustomText(
            text: title,
            fontSize: 18.0,
            color: AppUI.blackColor,
            fontWeight: FontWeight.w500,
          ),
    centerTitle: true,
    leading: leading,
    leadingWidth: leadingWidth ?? 110,
    actions: actions,
    bottom: bottomChild == null
        ? null
        : PreferredSize(
            preferredSize: Size.fromHeight(bottomChildHeight ?? 120),
            child: bottomChild,
          ),
  );
}

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Function()? onBack;

  const CustomAppBar({Key? key, required this.title, this.leading, this.onBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)),
        ),
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)),
            color: AppUI.whiteColor,
          ),
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: onBack ??
                        () {
                          Navigator.pop(context);
                        },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppUI.blackColor,
                      size: 19,
                    )),
                CustomText(
                  text: title,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                leading ??
                    const SizedBox(
                      width: 20,
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String? text;
  final double fontSize;
  final TextAlign? textAlign;
  final FontWeight fontWeight;
  final Color? color;
  final double? height;
  final int? max;
  final TextDecoration? textDecoration;

  const CustomText(
      {Key? key,
      @required this.text,
      this.max,
      this.fontSize = 14,
      this.textAlign,
      this.height,
      this.fontWeight = FontWeight.w400,
      this.color,
      this.textDecoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      textAlign: textAlign == null
          ? AppUtil.rtlDirection(context)
              ? TextAlign.right
              : TextAlign.left
          : textAlign,
      maxLines: max == null ? 1000 : max,
      style: TextStyle(
          color: color ?? AppUI.blackColor,
          height: height != null ? height : 1.6,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: AppUtil.rtlDirection(context) ? "cairo" : "Tajawal",
          decoration: textDecoration),
      textDirection: AppUtil.rtlDirection(context)
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color? color;
  final int radius;
  final String text;
  final Color? textColor, borderColor;
  final Function()? onPressed;
  final double? width, height;
  final Widget? child;

  const CustomButton(
      {Key? key,
      required this.text,
      this.onPressed,
      this.color,
      this.borderColor,
      this.radius = 15,
      this.textColor = Colors.white,
      this.width,
      this.child,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          height: 56,
          width: width ?? AppUtil.responsiveWidth(context) * 0.91,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(double.parse("$radius")),
              color: color ?? AppUI.mainColor,
              border:
                  borderColor == null ? null : Border.all(color: borderColor!)),
          alignment: Alignment.center,
          child: child ??
              CustomText(
                text: text,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: textColor,
              )),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? height, width;
  final Color? color;
  final double? elevation, radius, padding;
  final Color? border;
  final Function()? onTap;

  const CustomCard(
      {Key? key,
      required this.child,
      this.height,
      this.width,
      this.color,
      this.elevation,
      this.border,
      this.onTap,
      this.radius,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 15)),
        elevation: elevation ?? 4,
        child: Container(
          padding: EdgeInsets.all(padding ?? 15),
          width: width == null
              ? double.infinity
              : width == -1
                  ? null
                  : width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 15),
            border: border != null ? Border.all(color: border!) : null,
            color: color ?? AppUI.whiteColor,
          ),
          child: child,
        ),
      ),
    );
  }
}

class CustomInput extends StatelessWidget {
  final String? hint, lable;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function()? onTap;
  final Function(String v)? onChange;
  final bool obscureText, readOnly, autofocus, validation;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines, maxLength;
  final double radius;
  final TextAlign? textAlign;
  final Color? borderColor, fillColor;

  const CustomInput(
      {Key? key,
      required this.controller,
      this.hint,
      this.lable,
      required this.textInputType,
      this.obscureText = false,
      this.prefixIcon,
      this.suffixIcon,
      this.onTap,
      this.onChange,
      this.maxLines,
      this.textAlign,
      this.readOnly = false,
      this.autofocus = false,
      this.radius = 15.0,
      this.maxLength,
      this.validation = true,
      this.borderColor,
      this.fillColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onTap: onTap,
      readOnly: readOnly,
      // maxLength: maxLength,
      keyboardType: textInputType,
      textAlign: textAlign != null
          ? textAlign!
          : AppUtil.rtlDirection(context)
              ? TextAlign.right
              : TextAlign.left,
      onChanged: onChange,
      validator: validation
          ? (v) {
              if (v!.isEmpty) {
                return "fieldRequired".tr();
              }
              return null;
            }
          : null,
      autofocus: autofocus,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hint,
        counterStyle: TextStyle(fontSize: 0, height: 0),
        hintStyle: TextStyle(
          fontFamily: AppUtil.rtlDirection(context) ? "cairo" : "Tajawal",
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: suffixIcon,
        ),
        labelText: lable,

        // labelStyle: TextStyle(color: AppUI.secondColor),
        filled: true,
        fillColor: fillColor ?? AppUI.whiteColor,
        suffixIconConstraints: const BoxConstraints(minWidth: 63),
        prefixIcon: prefixIcon,
        contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: AppUtil.responsiveHeight(context) * 0.021),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
                topRight: Radius.circular(radius)),
            borderSide: BorderSide(color: borderColor ?? AppUI.shimmerColor)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
                topRight: Radius.circular(radius)),
            borderSide: BorderSide(color: borderColor ?? AppUI.shimmerColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
                topRight: Radius.circular(radius)),
            borderSide: BorderSide(
                color: borderColor ?? AppUI.shimmerColor, width: 0.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius)),
            borderSide: BorderSide(color: borderColor ?? AppUI.mainColor)),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/lottie/loading.json',
          height: 90, width: 90, fit: BoxFit.fill),
    );
  }
}

class CustomDropDownMenu extends StatelessWidget {
  final Function()? onTapElement;
  final element;

  const CustomDropDownMenu({Key? key, this.onTapElement, this.element})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppUI.mainColor),
      ),
      constraints: const BoxConstraints(maxHeight: 140),
      child: ListView(
        shrinkWrap: true,
        children: List.generate(8, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: onTapElement,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: element ?? "الرياض"),
                  if (index != 7) Divider()
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final type, buttonText;
  final product, from;
  final Function()? onFav, onDelete, addToCart, onTap;

  const ProductCard(
      {Key? key,
      this.type = "grid",
      this.buttonText,
      this.product,
      this.onFav,
      this.onDelete,
      this.from,
      this.addToCart,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            AppUtil.mainNavigator(
                context, ProductDetailsScreen(product: product!));
          },
      child: type == "grid"
          ? Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: product!.images != null
                            ? product!.images!.isEmpty
                                ? ""
                                : product!.images![0].src!
                            : "",
                        // fit: BoxFit.cover,
                        height: 250,
                        // placeholder: (context, url) => Stack(
                        //   children: [
                        //     Image.asset(
                        //       "${AppUI.imgPath}product_background.png",
                        //       height: 150,
                        //       fit: BoxFit.fill,
                        //     ),
                        //   ],
                        // ),
                        // width: double.infinity,
                        // placeholder: (context, url) => Stack(
                        //   children: const [
                        //     LoadingWidget(),
                        //     //Image.asset("${AppUI.imgPath}men.png",height: 270,width: double.infinity,fit: BoxFit.fill,),
                        //     // Image.asset("${AppUI.imgPath}boy.png",height: 270,width: double.infinity,fit: BoxFit.fill,),
                        //   ],
                        // ),
                        errorWidget: (context, url, error) => Stack(
                          children: [
                            Image.asset(
                              "${AppUI.imgPath}no_image.png",
                              height: 270,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                            // Image.asset("${AppUI.imgPath}boy.png",height: 270,width: double.infinity,fit: BoxFit.fill,),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 10),
                      child: Row(
                        children: [
                          // Container(
                          //   height: 20,
                          //   padding: const EdgeInsets.symmetric(horizontal: 4),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(3),
                          //     color: product!.salePrice==""?AppUI.orangeColor:AppUI.whiteColor,
                          //   ),
                          //   alignment: Alignment.center,
                          //   child: CustomText(text: product!.salePrice=="" || product!.salePrice == null?product!.stockStatus=="outofstock"?"outOfStock".tr():"inStock".tr() : "${int.parse((100-(int.parse(product!.salePrice!)/int.parse(product!.regularPrice==""?product!.price!:product!.regularPrice))*100).round().toString())}%",color: product!.salePrice==""?AppUI.whiteColor:AppUI.errorColor,fontSize: 10,)
                          // ),
                          const Spacer(),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: AppUI.whiteColor,
                                radius: 15,
                                child: SizedBox(),
                              ),
                              InkWell(
                                onTap: onFav,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Icon(
                                    product!.fav!
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: AppUI.errorColor,
                                    size: 20,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Expanded(
                  // flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        if (product!.categories != null)
                          // SizedBox(
                          //   height: 25,
                          //   width: AppUtil.responsiveWidth(context)*0.38,
                          //   child: SingleChildScrollView(
                          //     scrollDirection: Axis.horizontal,
                          //     child: Row(
                          //       children: List.generate(product!.categories.length, (index) {
                          //         return CustomText(text: "${product!.categories[index]['name']}${index == product!.categories.indexOf(product!.categories.last)?"":", "}",color: AppUI.iconColor.withOpacity(0.8),fontSize: 12,);
                          //       }),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 5,),
                          Text(""),
                        CustomText(
                          text:
                              "${product!.salePrice == "" ? product!.price : product.salePrice} SAR",
                          color: product!.salePrice == ""
                              ? AppUI.blackColor
                              : AppUI.alshiakaColor,
                          fontWeight: FontWeight.w600,
                        ),
                        if (product!.salePrice != "")
                          CustomText(
                            text:
                                "${product!.regularPrice == "" ? product!.price : product!.regularPrice} SAR",
                            color: AppUI.alshiakaColor,
                            textDecoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        Container(
                          width: MediaQuery.of(context).size.width * .38,
                          child: CustomText(
                            text: product!.name,
                            max: 2,
                            color: AppUI.alshiakaColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          : Column(
              children: [
                if (type.split(" ")[0] == "order")
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      children: [
                        // CustomText(text: "${"orderId".tr()} : #${product!.id}",fontWeight: FontWeight.w700,),
                        const Spacer(),
                        CustomText(
                          text: type.split(" ")[1] == "current"
                              ? "In Progress"
                              : "Delivered",
                          color: type.split(" ")[1] == "current"
                              ? AppUI.mainColor
                              : AppUI.activeColor,
                        )
                      ],
                    ),
                  ),
                Row(
                  children: [
                    if (type.split(" ")[0] == "order")
                      Expanded(
                        flex: 2,
                        child: CachedNetworkImage(
                          imageUrl:
                              product!.image != null ? product!.image.src! : "",
                          placeholder: (context, url) => Stack(
                            children: [
                              Image.asset(
                                "${AppUI.imgPath}product_background.png",
                                height: 150,
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                          errorWidget: (context, url, error) => Stack(
                            children: [
                              Image.asset(
                                "${AppUI.imgPath}product_background.png",
                                height: 170,
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        flex: 2,
                        child: CachedNetworkImage(
                          imageUrl: product.image != null
                              ? product.image!['src']!
                              : product.images != null &&
                                      product.images!.isNotEmpty
                                  ? product.images![0].src!
                                  : "",
                          height: 130,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Stack(
                            children: [
                              Image.asset(
                                "${AppUI.imgPath}product_background.png",
                                height: 130,
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                          errorWidget: (context, url, error) => Stack(
                            children: [
                              Image.asset(
                                "${AppUI.imgPath}product_background.png",
                                height: 130,
                                fit: BoxFit.fill,
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width:
                                        AppUtil.responsiveWidth(context) * 0.6,
                                    child: CustomText(
                                      text: type.split(" ")[0] == "order"
                                          ? product!.name
                                          : product!.name,
                                      color: AppUI.blueColor,
                                    )),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomText(
                                  text: type.split(" ")[0] == "order"
                                      ? ''
                                      : product!.description!.length < 3
                                          ? product!.description
                                          : "${product!.description!.substring(3, product!.description!.length > 29 ? 24 : product!.description!.length - 5)}...",
                                  color: AppUI.blackColor,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                if (type.split(" ")[0] == "order")
                                  CustomText(
                                    text:
                                        "${product!.price.toString().length > 6 ? product!.price.toString().substring(0, 6) : product!.price.toString()} SAR",
                                    color: AppUI.mainColor,
                                    fontWeight: FontWeight.w600,
                                  )
                                else
                                  CustomText(
                                    text:
                                        "${product!.salePrice == "" ? product!.price : product!.salePrice} SAR",
                                    color: product!.salePrice == ""
                                        ? AppUI.mainColor
                                        : AppUI.orangeColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                if (type.split(" ")[0] != "order")
                                  if (product!.salePrice != "")
                                    CustomText(
                                      text: "${product!.price} SAR",
                                      color: AppUI.iconColor,
                                      textDecoration:
                                          TextDecoration.lineThrough,
                                      fontSize: 12,
                                    ),
                                const SizedBox(
                                  height: 5,
                                ),
                                if (type.split(" ")[0] != "order")
                                  if (product.attributes.isNotEmpty &&
                                      product.attributes[0]['option'] != null)
                                    Row(
                                      children: [
                                        CustomText(
                                          text: product.attributes[0]['name'],
                                          color: AppUI.iconColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        CustomText(
                                          text: product.attributes[0]['option'],
                                          color: AppUI.blackColor,
                                        ),
                                      ],
                                    ),
                                // SizedBox(
                                //   height: 25,
                                //   width: AppUtil.responsiveWidth(context)*0.38,
                                //   child: SingleChildScrollView(
                                //     scrollDirection: Axis.horizontal,
                                //     child: Row(
                                //       children: List.generate(product!.categories.length, (index) {
                                //         return CustomText(text: "${product!.categories[index]['name']}${index == product!.categories.indexOf(product!.categories.last)?"":", "}",color: AppUI.blackColor,);
                                //       }),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                if (type.split(" ")[0] != "order")
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            await FlutterShare.share(
                                title: product!.name!,
                                linkUrl: product!.permalink!,
                                chooserTitle: 'Share ${product!.name}');
                          },
                          child: Icon(
                            Icons.share_outlined,
                            color: AppUI.blackColor,
                            size: 19,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 20,
                          width: 1,
                          color: AppUI.greyColor,
                        ),
                        if (type.split(" ")[0] != "order" ||
                            type.split(" ")[0] == "order" &&
                                type.split(" ")[1] == "current")
                          InkWell(
                              onTap: onDelete,
                              child: Image.asset(
                                "${AppUI.imgPath}trash_red.png",
                                height: 19,
                              )),
                        const Spacer(),
                        InkWell(
                            onTap: addToCart,
                            child: Row(
                              children: [
                                Image.asset(
                                  "${AppUI.imgPath}bag.png",
                                  color: AppUI.mainColor,
                                  height: 19,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomText(
                                  text: "addToBag".tr(),
                                  color: AppUI.mainColor,
                                )
                              ],
                            )),
                      ],
                    ),
                  )
              ],
            ),
    );
  }
}

class CustomCreditCard extends StatelessWidget {
  final String? cardHolder, cardNum, expiryDate, cvv;

  const CustomCreditCard(
      {Key? key, this.cardHolder, this.cardNum, this.cvv, this.expiryDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Image.asset("${AppUI.imgPath}visa.png"),
        Positioned(
          right: 30,
          top: 30,
          child: Image.asset(
            "${AppUI.imgPath}visa_text.png",
            width: 60,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: cardNum ?? "4343234543453454",
                fontSize: 22,
                color: AppUI.whiteColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  CustomText(
                    text: "Card Holder",
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                    color: AppUI.whiteColor,
                  ),
                  const Spacer(),
                  CustomText(
                    text: "Expire",
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                    color: AppUI.whiteColor,
                  ),
                ],
              ),
              Row(
                children: [
                  CustomText(
                    text: cardHolder ?? "ahmed mohamed".toUpperCase(),
                    color: AppUI.whiteColor,
                  ),
                  const Spacer(),
                  CustomText(
                    text: expiryDate ?? "03/22",
                    color: AppUI.whiteColor,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

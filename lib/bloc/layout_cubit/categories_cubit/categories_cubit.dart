import 'dart:convert';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/models/categories/banner_model.dart';
import 'package:ahshiaka/models/categories/products_model.dart';
import 'package:ahshiaka/models/categories/reviews_model.dart';
import 'package:ahshiaka/models/categories/size_guide_model.dart';
import 'package:ahshiaka/models/home_menu_model.dart';
import 'package:ahshiaka/repository/categories_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:string_similarity/string_similarity.dart';

import '../../../models/categories/categories_model.dart';
import '../../../models/categories/products_count_model.dart';
import '../../../shared/cash_helper.dart';
import '../../../utilities/app_util.dart';
import 'categories_states.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());
  static CategoriesCubit get(context) => BlocProvider.of(context);
  List<ProductModel> favProducts = [];

  changeTabState() {
    emit(CategoriesChangeTabState());
  }

  // final homeScrollController = ScrollController();

  int selectedCatId = 0;
  var searchController = TextEditingController();

  List<CategoriesModel> allSubCategoriesModel = [];
  List<CategoriesModel> categoriesModel = [];
  List<CategoriesModel> subCategoriesModel = [];
  List<CategoriesModel> subSubCategoriesModel = [];
  int catInitIndex = 0;
  int initialIndex = 0;
  TabController? tapBarController;
  fetchCategories() async {
    categoriesModel.clear();
    allSubCategoriesModel.clear();
    String lang = await CashHelper.getSavedString("lang", "en");
    print('lang $lang');
    emit(CategoriesLoadingState());
    try {
      Map<String, dynamic> response =
          await CategoriesRepository.fetchCategories(lang);
      List data = response["items"];
      for (var element in data) {
        // if (element['parent'] == 0) {
        //   categoriesModel.add(CategoriesModel.fromJson(element));
        // } else {
        //   allSubCategoriesModel.add(CategoriesModel.fromJson(element));
        // }
        categoriesModel.add(CategoriesModel.fromJson(element));
      }
      print(categoriesModel.length);
      print(allSubCategoriesModel.length);
      print(
          "******************************************************************");
      if (categoriesModel.isEmpty) {
        emit(CategoriesEmptyState());
      } else {
        // categoriesModel
        //     .removeWhere((element) => element.name == "Uncategorized");
        // categoriesModel.removeWhere((element) => element.name == "غير مصنف");
        emit(CategoriesLoadedState());
        // for (var element in categoriesModel) {
        // fetchSubCategories(element.id!.toString());
        // }
        for (var element in categoriesModel) {
          if (element.childItems != null) {
            allSubCategoriesModel.addAll(element.childItems!);
            fetchSubCategories(element.id);
          }
        }
      }
    } catch (e) {
      emit(CategoriesErrorState());
      return Future.error(e);
    }
  }

  fetchSubCategories(catId) {
    subCategoriesModel.clear();
    for (var element in allSubCategoriesModel) {
      if (element.parent == catId) {
        subCategoriesModel.add(element);
      }
    }
    emit(SubCategoriesChangeState());
  }

  fetchSubSubCategories(catId) {
    subSubCategoriesModel.clear();
    for (var element in allSubCategoriesModel) {
      if (element.parent == catId) {
        subSubCategoriesModel.add(element);
      }
    }
    emit(SubCategoriesChangeState());
  }

  List<ProductModel> productModel = [];
  List<ProductModel> productModel2 = [];
  // List<ProductModel> get productModel => _productModel;

  List favList = [];
  final List _selectedAttributeIndex = [];
  final Map _selectedCustomizations = {};

  List get selectedAttributeIndex => _selectedAttributeIndex;
  Map get selectedCustomizations => _selectedCustomizations;

  // final ScrollController productScrollController = ScrollController();
  // final ScrollController productScrollController2 = ScrollController();
  int productPage = 1;
  fetchProductsByCategory(
      {required int catId,
      required int page,
      required perPage,
      filterParams,
      minPrice,
      maxPrice,
      ratingCount,
      String? name}) async {
    if (page == 0) {
      page = 1;
    }
    if (page == 1) {
      productPage = 1;
      productModel.clear();
    }
    favList = favProducts;
    if (page == 1) {
      emit(ProductsLoadingState());
    } else {
      emit(ProductsLoadingPaginateState());
    }
    print('page: $page');
    try {
      print(catId);
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2222");
      List response = await CategoriesRepository.fetchProductsByCategory(
          catId: catId,
          page: page,
          perPage: perPage,
          filterParams: filterParams,
          maxPrice: maxPrice,
          minPrice: minPrice,
          ratingCount: ratingCount,
          name: name);
      for (var element in response) {
        productModel.add(ProductModel.fromJson(element));
        print(productModel.length);
      }
      if (response.isEmpty) {
        productPage--;
      }
      if (productModel.isEmpty) {
        emit(ProductsEmptyState());
      } else {
        for (ProductModel favItem in favList) {
          for (ProductModel product in productModel) {
            if (favItem.id == product.id) {
              product.fav = true;
              break;
            }
          }
        }
        emit(ProductsLoadedState());
      }
    } catch (e) {
      emit(ProductsErrorState());
      return Future.error(e);
    }
  }

  getFilteredProducts({
    required catId,
    attributes,
    order,
    orderBy,
    required perPage,
    required page,
    minPrice,
    maxPrice,
  }) async {
    if (page == 0) {
      page = 1;
    }
    if (page == 1) {
      productPage = 1;
      productModel.clear();
    }
    favList = favProducts;
    if (page == 1) {
      emit(ProductsLoadingState());
    } else {
      emit(ProductsLoadingPaginateState());
    }
    print('page: $page');
    try {
      print(catId);
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2222");
      List response = await CategoriesRepository.getFilteredProducts(
        catId: catId,
        attributes: attributes,
        order: order,
        orderBy: orderBy,
        perPage: perPage,
        page: page,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      for (var element in response) {
        productModel.add(ProductModel.fromJson(element));
        print(productModel.length);
      }
      if (response.isEmpty) {
        productPage--;
      }
      if (productModel.isEmpty) {
        emit(ProductsEmptyState());
      } else {
        for (ProductModel favItem in favList) {
          for (ProductModel product in productModel) {
            if (favItem.id == product.id) {
              product.fav = true;
              break;
            }
          }
        }
        emit(ProductsLoadedState());
      }
    } catch (e) {
      emit(ProductsErrorState());
      return Future.error(e);
    }
  }

  fetchProductsByCategory2(
      {required var catId,
      required int page,
      required perPage,
      filterParams,
      minPrice,
      maxPrice,
      ratingCount,
      String? name}) async {
    if (page == 0) {
      page = 1;
    }
    if (page == 1) {
      productPage = 1;
      productModel2.clear();
    }
    favList = favProducts;
    if (page == 1) {
      emit(ProductsLoadingState());
    } else {
      emit(ProductsLoadingPaginateState());
    }
    print('page: $page');
    try {
      List response = await CategoriesRepository.fetchProductsByCategory2(
          catId: catId,
          page: page,
          perPage: perPage,
          filterParams: filterParams,
          maxPrice: maxPrice,
          minPrice: minPrice,
          ratingCount: ratingCount,
          name: name);
      for (var element in response) {
        print(
            "forrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr $element forrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
        productModel2.add(ProductModel.fromJson(element));
      }
      print(productModel2.length);
      print(
          "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555");
      if (response.isEmpty) {
        productPage--;
      }
      if (productModel2.isEmpty) {
        emit(ProductsEmptyState());
      } else {
        for (ProductModel favItem in favList) {
          for (ProductModel product in productModel2) {
            if (favItem.id == product.id) {
              product.fav = true;
              break;
            }
          }
        }
        emit(ProductsLoadedState());
      }
    } catch (e) {
      emit(ProductsErrorState());
      return Future.error(e);
    }
  }

  fetchProductsByCategorySort(
      {required int catId,
      required int page,
      required perPage,
      filterParams,
      minPrice,
      maxPrice,
      ratingCount,
      String? name,
      String? orderBy,
      String? order}) async {
    if (page == 0) {
      page = 1;
    }
    if (page == 1) {
      productPage = 1;
      productModel.clear();
    }
    favList = favProducts;
    if (page == 1) {
      emit(ProductsLoadingState());
    } else {
      emit(ProductsLoadingPaginateState());
    }
    print('page: $page');
    try {
      print(catId);
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2222");
      List response = await CategoriesRepository.fetchProductsBySort(
          catId: catId,
          page: page,
          perPage: perPage,
          filterParams: filterParams,
          maxPrice: maxPrice,
          minPrice: minPrice,
          ratingCount: ratingCount,
          name: name,
          orderBy: orderBy,
          order: order);
      for (var element in response) {
        productModel.add(ProductModel.fromJson(element));
      }
      if (response.isEmpty) {
        productPage--;
      }
      if (productModel.isEmpty) {
        emit(ProductsEmptyState());
      } else {
        for (ProductModel favItem in favList) {
          for (ProductModel product in productModel) {
            if (favItem.id == product.id) {
              product.fav = true;
              break;
            }
          }
        }
        emit(ProductsLoadedState());
      }
    } catch (e) {
      emit(ProductsErrorState());
      return Future.error(e);
    }
  }

  ProductsCountModel? productsCount;
  getProductsCount({required int catId}) async {
    var response = await CategoriesRepository.getProductsCount(catId: catId);
    productsCount = ProductsCountModel.fromJson(response);
    emit(GetProductsCountState());
  }

  List<ProductModel> newArrivalProduct = [];

  fetchNewArrivalProducts(
      {required catId,
      required page,
      required perPage,
      minPrice,
      maxPrice,
      ratingCount,
      String? name}) async {
    favList = favProducts;
    if (page == 1) {
      newArrivalProduct.clear();
      emit(ProductsLoadingState());
    } else {
      emit(ProductsLoadingPaginateState());
    }
    try {
      List response = await CategoriesRepository.fetchProductsByCategory(
          catId: catId,
          page: page,
          perPage: perPage,
          maxPrice: maxPrice,
          minPrice: minPrice,
          ratingCount: ratingCount,
          name: name);
      for (var element in response) {
        newArrivalProduct.add(ProductModel.fromJson(element));
      }

      if (newArrivalProduct.isEmpty) {
        emit(ProductsEmptyState());
      } else {
        for (ProductModel favItem in favList) {
          for (ProductModel product in newArrivalProduct) {
            if (favItem.id == product.id) {
              product.fav = true;
              break;
            }
          }
        }
        emit(ProductsLoadedState());
      }
    } catch (e) {
      emit(ProductsErrorState());
      return Future.error(e);
    }
  }

  List<ProductModel> relatedProducts = [];

  fetchRelatedProducts(
      {required catId,
      required page,
      required perPage,
      minPrice,
      maxPrice,
      ratingCount,
      String? name}) async {
    relatedProducts.clear();
    favList = favProducts;
    if (page == 1) {
      emit(RelatedProductsLoadingState());
    } else {
      emit(RelatedProductsLoadingPaginateState());
    }
    try {
      List response = await CategoriesRepository.fetchProductsByCategory(
          catId: catId,
          page: page,
          perPage: perPage,
          maxPrice: maxPrice,
          minPrice: minPrice,
          ratingCount: ratingCount,
          name: name);
      for (var element in response) {
        relatedProducts.add(ProductModel.fromJson(element));
      }

      if (relatedProducts.isEmpty) {
        emit(RelatedProductsEmptyState());
      } else {
        for (ProductModel favItem in favList) {
          for (ProductModel product in relatedProducts) {
            if (favItem.id == product.id) {
              product.fav = true;
              break;
            }
          }
        }
        emit(RelatedProductsLoadedState());
      }
    } catch (e) {
      emit(RelatedProductsErrorState());
      return Future.error(e);
    }
  }

  List<ProductModel> recommendedProduct = [];

  fetchRecommendedProducts(
      {required catId,
      required page,
      required perPage,
      minPrice,
      maxPrice,
      ratingCount,
      String? name}) async {
    favList = favProducts;
    if (page == 1) {
      recommendedProduct.clear();
      emit(ProductsLoadingState());
    } else {
      emit(ProductsLoadingPaginateState());
    }
    String recoCatId = await CashHelper.getSavedString("recoCatId", "0");
    try {
      List response = await CategoriesRepository.fetchProductsByCategory(
          catId: int.parse(recoCatId),
          page: page,
          perPage: perPage,
          maxPrice: maxPrice,
          minPrice: minPrice,
          ratingCount: ratingCount,
          name: name);
      for (var element in response) {
        recommendedProduct.add(ProductModel.fromJson(element));
      }

      if (recommendedProduct.isEmpty) {
        emit(ProductsEmptyState());
      } else {
        for (ProductModel favItem in favList) {
          for (ProductModel product in recommendedProduct) {
            if (favItem.id == product.id) {
              product.fav = true;
              break;
            }
          }
        }
        emit(ProductsLoadedState());
      }
    } catch (e) {
      emit(ProductsErrorState());
      return Future.error(e);
    }
  }

  fetchFavProducts() async {
    String email = await CashHelper.getSavedString("email", "");
    favProducts.clear();
    // if(email == ""){
    String favListString =
        await CashHelper.getSavedString("${email}favList", "");
    if (favListString == "[]" || favListString == "") {
      emit(FavEmptyState());
      favProducts = [];
      return [];
    } else {
      jsonDecode(favListString).forEach((element) {
        favProducts.add(ProductModel.fromJson(element));
      });
      emit(FavLoadedState());
      return favProducts;
    }
    // }else{
    //   favProducts = await fetchFavProductsWithApi(email);
    // }
  }

  fetchFavProductsWithApi(email) async {
    emit(FavLoadingState());
    favProducts.clear();
    try {
      List response =
          await CategoriesRepository.fetchFavProductsWithApi(email: email);
      List<ProductModel> productModel = [];
      for (var element in response) {
        productModel.add(ProductModel.fromJson(element));
        favProducts.add(ProductModel.fromJson(element));
      }
      if (favProducts.isEmpty) {
        emit(FavEmptyState());
      } else {
        emit(FavLoadedState());
      }
    } catch (e) {
      emit(FavErrorState());
      return Future.error(e);
    }
    return favProducts;
  }

  favProduct(ProductModel product, context) async {
    print(product.fav);
    String email = await CashHelper.getSavedString("email", "");
    // if(email =="") {
    for (var element in productModel) {
      if (element.id == product.id) {
        element.fav = true;
      }
    }

    for (var element in newArrivalProduct) {
      if (element.id == product.id) {
        element.fav = true;
      }
    }
    for (var element in recommendedProduct) {
      if (element.id == product.id) {
        element.fav = false;
      }
    }

    for (var element in relatedProducts) {
      if (element.id == product.id) {
        element.fav = false;
      }
    }

    for (var element in CheckoutCubit.get(context).cartList) {
      if (element.id == product.id) {
        element.fav = false;
      }
    }
    for (var e in homeMenuModel) {
      for (var element in e) {
        if (element.id == product.id) {
          element.fav = false;
        }
      }
    }

    List favList = await fetchFavProducts();
    if (favList.isNotEmpty) {
      for (int i = 0; i < favList.length; i++) {
        if (favList[i].id == product.id) {
          product.fav = false;
          favList.removeAt(i);
          CashHelper.setSavedString("${email}favList", jsonEncode(favList));
          emit(ChangeFavState());
          return;
        }
      }
      product.fav = true;
      favList.add(product);
      CashHelper.setSavedString("${email}favList", jsonEncode(favList));
    } else {
      product.fav = true;
      CashHelper.setSavedString(
          "${email}favList", jsonEncode([product.toJson()]));
    }
    await fetchFavProducts();
    emit(ChangeFavState());
    // }else{
    //   product.fav = !product.fav!;
    //   emit(ChangeFavState());
    //   favProductWithApi(email: email, wishListId: wishlistId, productId: product.id!, favState: product.fav);
    // }
  }

  favProductWithApi(
      {required email,
      required wishListId,
      required productId,
      required favState}) async {
    try {
      if (favState) {
        await CategoriesRepository.favProductWithApi(
            email: email, wishListId: "0", productId: productId);
      } else {
        await CategoriesRepository.unFavProductWithApi(
            email: email, wishListId: "0", productId: productId);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  removeFromFav(ProductModel product, context) async {
    print('kjnfn ${favProducts}');
    String email = await CashHelper.getSavedString("email", "");
    favProducts.removeWhere((element) => element.id == product.id);
    print('kjnfn ${favProducts}');

    for (var element in productModel) {
      if (element.id == product.id) {
        element.fav = false;
      }
    }

    for (var element in newArrivalProduct) {
      if (element.id == product.id) {
        element.fav = false;
      }
    }

    for (var element in recommendedProduct) {
      if (element.id == product.id) {
        element.fav = false;
      }
    }

    for (var element in relatedProducts) {
      if (element.id == product.id) {
        element.fav = false;
      }
    }

    for (var element in CheckoutCubit.get(context).cartList) {
      if (element.id == product.id) {
        element.fav = false;
      }
    }

    for (var e in homeMenuModel) {
      for (var element in e) {
        if (element.id == product.id) {
          element.fav = false;
        }
      }
    }

    emit(ChangeFavState());
    emit(ProductsLoadedState());
    // if(email == "") {
    await CashHelper.setSavedString("${email}favList", jsonEncode(favProducts));
    // CheckoutCubit.get(context).cartList.forEach((element) {
    //
    // });
    await CashHelper.setSavedString(
        "${email}cartList", jsonEncode(CheckoutCubit.get(context).cartList));

    // await CheckoutCubit.get(context).fetchCartList(context);
    // }else{
    //   await CategoriesRepository.unFavProductWithApi(
    //       email: email, wishListId: wishlistId, productId: product.id);
    // }
  }

  fetchProductAttributes(ProductModel product) {
    selectedAttributeIndex.clear();
    for (int i = 0; i < product.attributes!.length; i++) {
      _selectedAttributeIndex.add({
        "index": 0,
        "name": product.attributes![i].options == null
            ? product.attributes![i].option
            : product.attributes![i].options![0]
      });
    }
  }

  setSelectedAttributesIndex(
      int selectedSizeIndex, mainListIndex, optionName, int id) {
    _selectedAttributeIndex.insert(mainListIndex,
        {"index": selectedSizeIndex, "name": optionName, "attributeId": id});
    _selectedAttributeIndex.removeAt(mainListIndex + 1);
    emit(AttributeChangeState());
  }

  setCustomizations(int id, int? variantId, String size, String tall) async {
    print('variant id: $variantId');
    _selectedCustomizations.addAll({
      '$variantId': {"Width".tr(): size, "Length".tr(): tall}
    });
    emit(CustomizationChangeState());
  }

  // CartModel? cartModel;
  addToCart(
    BuildContext context,
    ProductModel product, {
    String? variantId,
  }) async {
    final cubit = CategoriesCubit.get(context);
    String email = await CashHelper.getSavedString("email", "");
    String cartListString =
        await CashHelper.getSavedString("${email}cartList", "");
    String cartKey = await CashHelper.getSavedString("cartKey", "");

    Map<String, dynamic> formData = {};
    if (cartListString != "") {
      List<ProductModel> cartList = [];
      jsonDecode(cartListString).forEach((element) {
        cartList.add(ProductModel.fromJson(element));
      });
      bool exists = false;
      for (var element in cartList) {
        if (element.attributes != null && element.attributes!.isNotEmpty) {
          if (element.mainProductId!.toString() == variantId!.toString()) {
            element.qty = element.qty! + 1;
            exists = true;

            formData = {
              "product_id": variantId.toString(),
              "quantity": element.qty.toString(),
            };

            break;
          }
        } else {
          if (element.id!.toString() == variantId!.toString()) {
            element.qty = element.qty! + 1;
            exists = true;

            formData = {
              "product_id": variantId.toString(),
              "quantity": element.qty.toString(),
            };

            break;
          }
        }
      }
      if (!exists) {
        formData = {
          "product_id": variantId!.toString(),
          "quantity": "1",
        };
        cartList.add(product);
      }
      print(formData);
      String email = await CashHelper.getSavedString("email", "");
      CashHelper.setSavedString("${email}cartList", jsonEncode(cartList));
    } else {
      CashHelper.setSavedString(
          "${email}cartList", jsonEncode([product.toJson()]));
    }
    if (product.categories != null && product.categories.isNotEmpty) {
      CashHelper.setSavedString(
          "recoCatId", product.categories[0]['id'].toString());
    }
    AppUtil.successToast(context, "addedSuccessfully".tr(), type: "cart");
    await CheckoutCubit.get(context).fetchCartList(context);
    await CashHelper.setSavedString(
        "selectedCustomizations", jsonEncode(cubit.selectedCustomizations));
  }

  getVariationId(List<ProductModel> variations, context,
      {fromFav = false}) async {
    int variantId = 0;
    Map<String, String> slugs = {};
    for (var variant in variations) {
      for (int i = 0; i < variant.attributes!.length; i++) {
        print(variant.id);
        if (StringSimilarity.compareTwoStrings(
                    selectedAttributeIndex[i]['name'].toString().toLowerCase(),
                    variant.attributes![i].option!.toLowerCase()) >
                0.4 &&
            variant.attributes![i].option!.length >=
                selectedAttributeIndex[i]['name'].toString().length) {
          variantId = variant.id!;
        } else {
          variantId = 0;
          break;
        }
      }
      if (variantId != 0) {
        for (var attr in variant.attributes!) {
          for (var mainAttr in attributes) {
            if (attr.id == mainAttr.id) {
              slugs.addAll({"attribute_${mainAttr.slug}": attr.option!});
            }
          }
        }
        break;
      }
    }
    if (!fromFav) {
      if (variations.isNotEmpty && variantId == 0) {
        AppUtil.errorToast(context, "noVariationFound".tr());
        return null;
      }
    }
    print(slugs);
    return [variantId, slugs];
  }

  fetchItemInCart({String? id}) async {
    String email = await CashHelper.getSavedString("email", "");
    List<ProductModel> cartList = [];
    String cartListString =
        await CashHelper.getSavedString("${email}cartList", "");
    if (cartListString == "") {
      return false;
    } else {
      jsonDecode(cartListString).forEach((element) {
        cartList.add(ProductModel.fromJson(element));
      });
    }
    for (var element in cartList) {
      if (element.attributes != null && element.attributes!.isNotEmpty) {
        if (element.mainProductId!.toString() == id!.toString()) {
          return true;
        }
      } else {
        if (element.id!.toString() == id!.toString()) {
          return true;
        }
      }
    }
    return false;
  }

  List<ProductModel> variations = [];
  fetchProductVariations(id) async {
    variations.clear();
    try {
      List response = await CategoriesRepository.fetchProductVariations(id);
      for (var element in response) {
        variations.add(ProductModel.fromJson(element));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  List<dynamic> customizations = [];
  int length = 0;
  bool isLoading = false;
  getCustomizations(id) async {
    customizations.clear();
    try {
      isLoading = true;
      List response = await CategoriesRepository.getCustomizations(id);
      length = response.first;
      for (var element in response.last) {
        customizations.add(element);
      }
    } catch (e) {
      return Future.error(e);
    } finally {
      isLoading = false;
    }
  }

  List<ReviewsModel> reviewsModel = [];
  double rating1 = 0;
  double rating2 = 0;
  double rating3 = 0;
  double rating4 = 0;
  double rating5 = 0;
  double averageCount = 0;
  fetchProductsReview(id) async {
    reviewsModel.clear();
    emit(ReviewsLoadingState());
    rating1 = 0;
    rating2 = 0;
    rating3 = 0;
    rating4 = 0;
    rating5 = 0;
    averageCount = 0;
    try {
      List response = await CategoriesRepository.fetchProductsReview(id);
      if (response.isEmpty) {
        emit(ReviewsEmptyState());
      } else {
        double sumReviews = 0;
        for (var element in response) {
          if (element['rating'] == 1) {
            rating1++;
          } else if (element['rating'] == 2) {
            rating2++;
          } else if (element['rating'] == 3) {
            rating3++;
          } else if (element['rating'] == 4) {
            rating4++;
          } else if (element['rating'] == 5) {
            rating5++;
          }
          sumReviews += element['rating']!;
          reviewsModel.add(ReviewsModel.fromJson(element));
        }
        averageCount = sumReviews / reviewsModel.length;

        emit(ReviewsLoadedState());
      }
    } catch (e) {
      emit(ReviewsErrorState());
      return Future.error(e);
    }
  }

  double rateAdded = 5;
  var commentController = TextEditingController();
  Map<String, dynamic>? addReviewResponse;
  addReview(id) async {
    String email = await CashHelper.getSavedString("email", "");
    String name = await CashHelper.getSavedString("name", "");
    Map<String, String> formData = {
      "product_id": id.toString(),
      "review": commentController.text,
      "reviewer": name,
      "reviewer_email": email,
      "rating": rateAdded.toString()
    };
    emit(AddReviewsLoadingState());
    try {
      addReviewResponse = await CategoriesRepository.addReview(formData);
      fetchProductsReview(id);
      emit(AddReviewsLoadedState());
    } catch (e) {
      emit(AddReviewsErrorState());
      return Future.error(e);
    }
  }

  List<BannerModel> bannerModel = [];
  fetchBanner() async {
    try {
      var response = await CategoriesRepository.fetchBanner();
      print('response $response');
      for (var element in response) {
        bannerModel.add(BannerModel.fromJson(element));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  List<List<ProductModel>> homeMenuModel = [];
  List<Link> linkList = [];
  fetchHomeMenu(
      {required catId,
      required page,
      required perPage,
      colorFilter,
      sizeFilter,
      minPrice,
      maxPrice,
      ratingCount,
      String? name}) async {
    favList = favProducts;
    if (page == 1) {
      homeMenuModel.clear();
      emit(ProductsLoadingState());
    } else {
      emit(ProductsLoadingPaginateState());
    }
    try {
      List responseCat = await CategoriesRepository.fetchHomeMenu();
      for (int i = 0; i < responseCat.length; i++) {
        if (responseCat[i]['link']['object'] == "product_cat") {
          linkList.add(Link.fromJson(responseCat[i]['link']));
          homeMenuModel.add([]);
          responseCat[i]['products'].forEach((element) {
            homeMenuModel[i].add(ProductModel.fromJson(element));
          });
        }
      }
      emit(ProductsLoadedState());
    } catch (e) {
      emit(ProductsErrorState());
      return Future.error(e);
    }
  }

  List<SizeGuideModel> sizeGuideList = [];
  fetchSizeGuide(productId) async {
    sizeGuideList.clear();
    try {
      emit(SizeGuideLoadingState());
      List response = await CategoriesRepository.fetchSizeGuide(productId);
      for (var element in response) {
        sizeGuideList.add(SizeGuideModel.fromJson(element));
      }
      if (sizeGuideList.isNotEmpty) {
        emit(SizeGuideLoadedState());
      } else {
        emit(SizeGuideEmptyState());
      }
    } catch (e) {
      emit(SizeGuideErrorState());
      return Future.error(e);
    }
  }

  List<Attributes> attributes = [];
  var sizeController = [];
  var slugController = [];

  fetchAttributes() async {
    attributes.clear();
    try {
      // emit(SizeGuideLoadingState());
      List response = await CategoriesRepository.fetchAttributes();
      for (var element in response) {
        // if (element['id'] == 35 ||
        //     element['id'] == 28 ||
        //     element['id'] == 43 ||
        //     element['id'] == 15 ||
        //     element['id'] == 32) {
        if (element['id'] == 19 ||
            element['id'] == 16 ||
            element['id'] == 36 ||
            element['id'] == 40 ||
            element['id'] == 35) {
          attributes.add(Attributes.fromJson(element));
          sizeController.add(TextEditingController());
          slugController.add(TextEditingController());
        }
      }
      // if(attributes.isNotEmpty){
      //   // emit(SizeGuideLoadedState());
      // }else{
      //   // emit(SizeGuideEmptyState());
      // }
    } catch (e) {
      // emit(SizeGuideErrorState());
      return Future.error(e);
    }
  }

  List<Attributes> attributeTerms = [];
  fetchAttributeTerms(categoryId, attributeId) async {
    attributeTerms.clear();
    try {
      // emit(SizeGuideLoadingState());
      List response = await CategoriesRepository.fetchAttributeTerms(
          categoryId, attributeId);
      for (var element in response) {
        attributeTerms.add(Attributes.fromJson(element));
      }
      // if(attributes.isNotEmpty){
      //   // emit(SizeGuideLoadedState());
      // }else{
      //   // emit(SizeGuideEmptyState());
      // }
    } catch (e) {
      // emit(SizeGuideErrorState());
      return Future.error(e);
    }
  }
}

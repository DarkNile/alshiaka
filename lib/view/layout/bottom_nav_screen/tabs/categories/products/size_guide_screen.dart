import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_states.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
class SizeGuideScreen extends StatefulWidget {
  final String? title,productId;
  final List<String>? options;
  const SizeGuideScreen({Key? key, this.title, this.options,this.productId}) : super(key: key);

  @override
  _SizeGuideScreenState createState() => _SizeGuideScreenState();
}

class _SizeGuideScreenState extends State<SizeGuideScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CategoriesCubit.get(context).fetchSizeGuide(widget.productId);
  }
  @override
  Widget build(BuildContext context) {
    final cubit = CategoriesCubit.get(context);
    return CheckNetwork(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: "sizeGuide".tr()),
              const SizedBox(height: 20,),
              BlocBuilder<CategoriesCubit,CategoriesState>(
                buildWhen: (_,state) => state is SizeGuideLoadingState || state is SizeGuideLoadedState || state is SizeGuideEmptyState || state is SizeGuideErrorState,
                builder: (context, state) {
                  if(state is SizeGuideLoadingState){
                    return const LoadingWidget();
                  }
                  if(state is SizeGuideEmptyState){
                    return Center(child: CustomText(text: "noDataAvailable".tr()),);
                  }

                  if(state is SizeGuideEmptyState){
                    return Center(child: CustomText(text: "errorFetch".tr()),);
                  }

                  return ListView(
                    shrinkWrap: true,
                    children: List.generate(cubit.sizeGuideList.length, (index) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(cubit.sizeGuideList[index].tabs!.length, (subIndex) {
                          return Column(
                            children: [
                              SizedBox(
                                  width: AppUtil.responsiveWidth(context)*0.7,
                                  child: CustomText(text: cubit.sizeGuideList[index].tabs![subIndex].toUpperCase(),fontSize: 16,textAlign: TextAlign.center,)),
                              const SizedBox(height: 40,),
                              Column(
                                children: List.generate(cubit.sizeGuideList[index].tables[subIndex].length, (index2) {
                                  return  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        color: index2%2==0?AppUI.whiteColor:AppUI.shimmerColor.withOpacity(0.6),
                                        height: 35,
                                        child: Row(
                                          children: List.generate(cubit.sizeGuideList[index].tables[subIndex][index2].length, (index3) {
                                            return Expanded(child: CustomText(text: cubit.sizeGuideList[index].tables[subIndex][index2][index3].toString(),fontSize: 10,));
                                          }),
                                        ),
                                      ),
                                      const SizedBox(height: 7,)
                                    ],
                                  );
                                }),
                              ),
                              const SizedBox(height: 40,)
                            ],
                          );
                        }),
                      );
                    }),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

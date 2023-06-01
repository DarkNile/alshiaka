import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_nav_states.dart';

class BottomNavCubit extends Cubit<BottomNavState>{
  BottomNavCubit() : super(BottomNavInit());
  static BottomNavCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  setCurrentIndex(index){
    currentIndex = index;
    emit(ChangeState());
  }

}
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/shared/network/local/cache_helper.dart';
import 'package:meta/meta.dart';

part 'mode_state.dart';

class ModeCubit extends Cubit<ModeState> {
  ModeCubit() : super(ModeInitial());

  static ModeCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  void changeMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(MarketChangeModeState());
      });
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(MarketChangeModeState());
      });
    }
  }
}

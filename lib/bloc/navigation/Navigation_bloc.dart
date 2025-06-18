import 'package:bloc/bloc.dart';
part 'Navigation_event.dart';
part 'Navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(0)) {
    on<NavigationItemSelected>((event, emit) {
      emit(NavigationState(event.index));
    });
  }
}

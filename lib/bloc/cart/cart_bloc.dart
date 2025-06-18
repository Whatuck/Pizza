import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  String userID = '1';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CartBloc() : super(CartInitial()) {
    on<AddItemEvent>(_onAddItem);
    on<RemoveItemEvent>(_onRemoveItem);
    on<UpdateNumberEvent>(_onUpdateNumber);
    on<ClearCartEvent>(_onClearCart);
    on<LoadCartEvent>(_onLoadCart);

    add(LoadCartEvent());
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());

    final doc = await firestore.collection('Cart').doc(userID).get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final items =
          (data['items'] as List)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  name: item['name'],
                  price: item['price'],
                  picture: item['picture'],
                  number: item['number'],
                ),
              )
              .toList();
      emit(CartLoaded(items));
    } else {
      emit(CartInitial());
    }
  }

  Future<void> _saveCart(List<CartItem> items) async {
    await firestore.collection('Cart').doc(userID).set({
      'items':
          items
              .map(
                (item) => {
                  'id': item.id,
                  'name': item.name,
                  'price': item.price,
                  'picture': item.picture,
                  'number': item.number,
                },
              )
              .toList(),
      'last_updated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _onAddItem(AddItemEvent event, Emitter<CartState> emit) async {
    if (state is! CartLoaded) {
      emit(CartLoaded([event.item]));
      await _saveCart([event.item]);
      return;
    }

    final currentState = state as CartLoaded;
    final items = List<CartItem>.from(currentState.items);

    final index = items.indexWhere((item) => item.id == event.item.id);

    if (index >= 0) {
      items[index] = items[index].copyWith(number: items[index].number + 1);
    } else {
      items.add(event.item);
    }

    emit(CartLoaded(items));
    await _saveCart(items);
  }

  Future<void> _onRemoveItem(
    RemoveItemEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartLoaded) return;

    final currentState = state as CartLoaded;
    final items =
        currentState.items.where((item) => item.id != event.itemID).toList();

    final newState = items.isEmpty ? CartInitial() : CartLoaded(items);
    emit(newState);
    await _saveCart(items);
  }

  Future<void> _onUpdateNumber(
    UpdateNumberEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartLoaded) return;

    final currentState = state as CartLoaded;
    final items = List<CartItem>.from(currentState.items);
    final index = items.indexWhere((item) => item.id == event.itemID);

    if (index >= 0) {
      final newNumber = event.number < 1 ? 1 : event.number;
      items[index] = items[index].copyWith(number: newNumber);
      emit(CartLoaded(items));
      await _saveCart(items);
    }
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartInitial());
    await firestore.collection('Cart').doc(userID).delete();
  }

  double getTotal() {
    if (state is CartLoaded) {
      return (state as CartLoaded).items.fold(
        0,
        (sum, item) => sum + (item.price * item.number),
      );
    }
    return 0.0;
  }
}

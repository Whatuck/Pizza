import '../../cart_item.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  CartLoaded(this.items);

  double get total =>
      items.fold(0, (sum, item) => sum + (item.price * item.number));
}

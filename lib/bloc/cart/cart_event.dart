import '../../cart_item.dart';

abstract class CartEvent {}

class LoadCartEvent extends CartEvent {}

class AddItemEvent extends CartEvent {
  final CartItem item;
  AddItemEvent(this.item);
}

class RemoveItemEvent extends CartEvent {
  final String itemID;
  RemoveItemEvent(this.itemID);
}

class UpdateNumberEvent extends CartEvent {
  final String itemID;
  final int number;
  UpdateNumberEvent(this.itemID, this.number);
}

class ClearCartEvent extends CartEvent {}

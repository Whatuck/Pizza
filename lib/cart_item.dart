class CartItem {
  String id;
  String name;
  double price;
  String picture;
  int number;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.picture,
    this.number = 1,
  });
  CartItem copyWith({int? number}) {
    return CartItem(
      id: id,
      name: name,
      price: price,
      picture: picture,
      number: number ?? this.number,
    );
  }
}

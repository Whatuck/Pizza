import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_page.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_state.dart';
import '../bloc/cart/cart_event.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaymentPage(),
              fullscreenDialog: true,
            ),
          );
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.payments_rounded, size: 35, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      appBar: AppBar(
        title: const Text("Корзина"),
        backgroundColor: Colors.amber,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial) {
            return const Center(child: Text('Ваша корзина пуста'));
          }
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartLoaded) {
            final items = state.items;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        leading:
                            item.picture.isNotEmpty
                                ? Image.network(
                                  item.picture,
                                  width: 50,
                                  height: 50,
                                )
                                : const Icon(Icons.shopping_cart),
                        title: Text(item.name),
                        subtitle: Text('${item.price} ₽ × ${item.number}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline_rounded,
                              ),
                              onPressed: () {
                                context.read<CartBloc>().add(
                                  UpdateNumberEvent(item.id, item.number - 1),
                                );
                              },
                            ),
                            Text(
                              '${item.number}',
                              style: TextStyle(fontSize: 17),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline_rounded,
                              ),
                              onPressed: () {
                                context.read<CartBloc>().add(
                                  UpdateNumberEvent(item.id, item.number + 1),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                size: 30,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context.read<CartBloc>().add(
                                  RemoveItemEvent(item.id),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Итого: ${state.total.toStringAsFixed(2)} ₽',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Ошибка'));
        },
      ),
    );
  }
}

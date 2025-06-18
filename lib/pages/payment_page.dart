import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_state.dart';
import '../bloc/cart/cart_event.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оформление заказа'),
        backgroundColor: Colors.green,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartInitial) {
            return const Center(child: Text('Ваша корзина всё ещё пуста'));
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
                        trailing: Text(
                          '${(item.price * item.number).toStringAsFixed(2)} ₽',
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Итого:', style: TextStyle(fontSize: 20)),
                    Text(
                      '${state.total.toStringAsFixed(2)} ₽',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () => _processPayment(context, state.total),
                    child: const Text(
                      'Оплатить',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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

  void _processPayment(BuildContext context, double total) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title:  Text('Оплачено:', style: TextStyle(fontSize: 25),),
            content: Text('${total.toStringAsFixed(2)} ₽', style: TextStyle(fontSize: 20),),
            actions: [
              TextButton(
                onPressed: () {
                  BlocProvider.of<CartBloc>(context).add(ClearCartEvent());
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
              ),
            ],
          ),
    );
  }
}

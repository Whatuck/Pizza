import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../cart_item.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  Widget menuList(BuildContext context, DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final name = data['Name'] ?? 'Ошибка';
    final picture =
        data['Picture'] ??
        'https://img.gazeta.ru/files3/374/21045374/okak-pic_32ratio_900x600-900x600-73058.jpg';
    final price = data['Price'] ?? '0';

    return ListTile(
      leading: Image.network(
        picture,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error_outline);
        },
      ),
      title: Text(name),
      subtitle: Text('$price ₽'),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 177, 153),
          iconSize: 28,
          iconColor: Colors.white,
          padding: EdgeInsets.zero,
          minimumSize: const Size(38, 38),
        ),
        onPressed: () {
          final cartBloc = BlocProvider.of<CartBloc>(context);

          final priceValue = double.tryParse(price.toString()) ?? 0.0;

          final cartItem = CartItem(
            id: doc.id,
            name: name,
            price: priceValue,
            picture: picture,
          );
          cartBloc.add(AddItemEvent(cartItem));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Good Pizza, Great Pizza"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('Menu')
                .orderBy('Category')
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Данные отсутствуют'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) => menuList(context, docs[index]),
          );
        },
      ),
    );
  }
}

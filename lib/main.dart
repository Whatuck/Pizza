import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/navigation/Navigation_bloc.dart';
import 'bloc/cart/cart_bloc.dart';
import 'pages/menu_page.dart';
import 'pages/cart_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationBloc()),
        BlocProvider(create: (_) => CartBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Pager());
  }
}

class Pager extends StatelessWidget {
  const Pager({super.key});

  final List<Widget> _pages = const [CartPage(), MenuPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return _pages[state.selectedIndex];
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<NavigationBloc>().add(NavigationItemSelected(index));
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Корзина',
                backgroundColor: Colors.amber,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_pizza_rounded),
                label: 'Меню',
                backgroundColor: Colors.deepOrangeAccent,
              ),
            ],
          );
        },
      ),
    );
  }
}

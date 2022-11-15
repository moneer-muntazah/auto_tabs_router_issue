import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

part 'main.gr.dart';

@CustomAutoRouter(
    transitionsBuilder: TransitionsBuilders.noTransition,
    replaceInRouteName: 'Page|Screen,Route',
    routes: [
      AutoRoute(path: '/', page: RootScreen, children: [
        AutoRoute(path: 'home', page: HomeScreen, initial: true),
        AutoRoute(path: 'category', page: CategoryScreen),
        AutoRoute(path: 'product', page: ProductScreen)
      ])
    ])
class AppRouter extends _$AppRouter {}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue), home: const App());
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        routeInformationProvider: appRouter.routeInfoProvider(),
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser());
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: [const HomeRoute(), const CategoryRoute(),
      ProductRoute(product: Product('dummy_id'))],
      builder: (context, child, animation) {
        return Row(
          children: [
            SizedBox(
                width: 120,
                child: Material(
                  child: Builder(
                    builder: (context) {
                      final tabRouter = AutoTabsRouter.of(context, watch: true);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                tabRouter.setActiveIndex(0);
                              },
                              icon: const Icon(Icons.home_filled)),
                          const SizedBox(height: 24),
                          IconButton(
                              onPressed: () {
                                tabRouter.setActiveIndex(1);
                              },
                              icon: const Icon(Icons.category)),
                        ],
                      );
                    },
                  ),
                )),
            Expanded(child: Scaffold(body: Center(child: child)))
          ],
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('HomeScreen');
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('CategoryScreen'),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: (){
          context.router.navigate(ProductRoute(product: Product('legit_id')));
        }, child: const Text('view legit product'))
      ],
    );
  }
}

class Product {
  Product(this.id);
  final String id;
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Text('ProductScreen with product.id = ${product.id}');
  }
}

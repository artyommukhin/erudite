import 'package:erudite_app/can_exit_controller.dart';
import 'package:erudite_app/game_route_observer.dart';
import 'package:erudite_app/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CanExitController()),
        Provider(create: (context) => GameRouteObserver())
      ],
      child: Consumer<GameRouteObserver>(
        builder: (context, routeObserver, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            navigatorObservers: [routeObserver],
            home: MainPage(),
          );
        },
      ),
    );
  }
}

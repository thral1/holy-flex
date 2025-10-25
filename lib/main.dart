import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/game_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HolyFlexApp());
}

class HolyFlexApp extends StatelessWidget {
  const HolyFlexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameService(),
      child: MaterialApp(
        title: 'Holy Flex',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Helvetica',
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

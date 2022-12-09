import 'package:add_n_show/screens/homepage/bindings/homepage_binding.dart';
import 'package:add_n_show/screens/homepage/view/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/home",
      getPages: [
        GetPage(
            name: "/home",
            page: (() => const HomePage()),
            binding: HomePageBinding())
      ],
    );
  }
}

import 'package:e_biz_card/models/contact_model.dart';
import 'package:e_biz_card/pages/contact_details_page.dart';
import 'package:e_biz_card/pages/form_page.dart';
import 'package:e_biz_card/pages/home_page.dart';
import 'package:e_biz_card/pages/scan_page.dart';
import 'package:e_biz_card/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ContactProvider(),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routerConfig: _router,
      builder: EasyLoading.init(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }

  final _router = GoRouter(debugLogDiagnostics: true, routes: [
    GoRoute(
      name: HomePage.routeName,
      path: HomePage.routeName,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(name: ContactDetailsPage.routeName,
          path: ContactDetailsPage.routeName,
          builder: (context, state) =>  ContactDetailsPage(id: state.extra! as int),
        ),
        GoRoute(
          name: ScanPage.routeName,
          path: ScanPage.routeName,
          builder: (context, state) => const ScanPage(),
          routes: [
            GoRoute(
                name: FormPage.routeName,
                path: FormPage.routeName,
                builder: (context, state) => FormPage( contactModel: state.extra! as ContactModel,)),
          ],
        ),
      ],
    ),
  ]);
}

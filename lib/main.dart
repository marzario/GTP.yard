import 'package:flutter/material.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:gtp_yard/pages/home_page/home_page_widget.dart';
import 'package:gtp_yard/pages/login_page/login_page_widget.dart';
import "package:supabase_flutter/supabase_flutter.dart";
import 'utils/flutter_flow_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:gtp_yard/pages/utils_page/search_page_placas.dart';
import 'package:gtp_yard/pages/exit_page/search_page_placa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //usePathUrlStrategy();
  // Load env
  await dotenv.load(fileName: "dot.env");
  // Initialize Supabase
  String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  await FlutterFlowTheme.initialize();

  runApp(MyApp());
}

enum AppRoute { home, login, placas, placa, ticketb }

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ThemeMode _themeMode = FlutterFlowTheme.themeMode;
  //final Locale? _locale;
  // _locale = createLocale("spanish");

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/loginpage',
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          name: "AppRoute.home.name",
          path: "/",
          builder: (context, state) => const HomePageWidget(),
        ),
        GoRoute(
          name: "AppRoute.login.name",
          path: "/loginpage",
          builder: (context, state) => const LoginPageWidget(),
        ),
        GoRoute(
          name: "AppRoute.placa.name",
          path: "/searchpageplaca",
          builder: (BuildContext context, GoRouterState state) {
            return const SearchPagePlaca();
          },
        ),
        GoRoute(
          name: "AppRoute.placas.name",
          path: "/searchpageplacas/:placa",
          builder: (BuildContext context, GoRouterState state) {
            final placa = state.pathParameters["placa"]!;
            return SearchPagePlacas(placa: placa);
          },
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      //locale: _locale,
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: _themeMode,
    );
  }
}

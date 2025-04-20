import "package:go_router/go_router.dart";
import "package:lg_kiss_app/screens/home.dart";
import "package:lg_kiss_app/screens/settings.dart";

final GoRouter router=GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/home',
    builder:(context,state)=>const HomeScreen()),
    GoRoute(path: '/settings',
    builder:(context,state)=>const SettingsScreen())
  ]);
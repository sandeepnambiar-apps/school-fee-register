import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import 'providers/student_provider.dart';
import 'providers/homework_provider.dart';
import 'providers/fee_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/students/students_screen.dart';
import 'screens/fees/fees_screen.dart';
import 'screens/homework/homework_screen.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/timetable/timetable_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/marks/marks_screen.dart';
import 'screens/reports/reports_screen.dart';
import 'screens/helpdesk/helpdesk_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => HomeworkProvider()),
        ChangeNotifierProvider(create: (_) => FeeProvider()),
      ],
      child: MaterialApp.router(
        title: 'Kidsy School Management System',
        theme: ThemeData(
          primarySwatch: Colors.grey,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.grey,
            brightness: Brightness.light,
            primary: Colors.grey[600],
            secondary: Colors.grey[400],
            surface: Colors.white,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[600],
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
            ),
          ),
        ),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/students',
      builder: (context, state) => const StudentsScreen(),
    ),
    GoRoute(
      path: '/fees',
      builder: (context, state) => const FeesScreen(),
    ),
    GoRoute(
      path: '/homework',
      builder: (context, state) => const HomeworkScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/timetable',
      builder: (context, state) => const TimetableScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/marks',
      builder: (context, state) => const MarksScreen(),
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: '/helpdesk',
      builder: (context, state) => const HelpDeskScreen(),
    ),
  ],
);

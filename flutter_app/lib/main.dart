import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'providers/auth_provider.dart';
import 'providers/student_provider.dart';
import 'providers/homework_provider.dart';
import 'providers/fee_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/timetable_provider.dart';
import 'providers/school_config_provider.dart';
import 'providers/multi_school_provider.dart';
import 'services/api_service.dart';
import 'providers/bus_tracking_provider.dart';
import 'providers/parent_provider.dart';
import 'screens/auth/school_code_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/create_password_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/students/students_screen.dart';
import 'screens/fees/fees_screen.dart';
import 'screens/homework/homework_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/reports/reports_screen.dart';
import 'screens/helpdesk/helpdesk_screen.dart';
import 'screens/marks/marks_screen.dart';
import 'screens/timetable/timetable_screen.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/settings/school_config_screen.dart';
import 'screens/bus_tracking/bus_tracking_screen.dart';
import 'screens/bus_tracking/driver_location_screen.dart';
import 'screens/parent/parent_login_screen.dart';
import 'screens/parent/parent_registration_screen.dart';
import 'screens/teacher/my_classes_screen.dart';
import 'screens/fees/fee_overview_screen.dart';
import 'screens/fees/transaction_summary_screen.dart';
import 'screens/fees/fee_details_screen.dart';
import 'screens/payment/payment_screen.dart';

void main() {
  // Initialize API service
  ApiService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MultiSchoolProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => HomeworkProvider()),
        ChangeNotifierProvider(create: (_) => FeeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => TimetableProvider()),
        ChangeNotifierProvider(create: (_) => SchoolConfigProvider()),
        ChangeNotifierProvider(create: (_) => BusTrackingProvider()),
        ChangeNotifierProvider(create: (_) => ParentProvider()),
      ],
      child: MaterialApp.router(
        title: 'School System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
          dialogTheme: const DialogThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _checkSchoolCodeStatus();
  }

  Future<void> _checkSchoolCodeStatus() async {
    final apiService = ApiService();
    final isVerified = await apiService.isSchoolCodeVerified();
    
    if (mounted) {
      if (isVerified) {
        // School code already verified, go to login
        context.go('/login');
      } else {
        // First time, show school code screen
        context.go('/school-code');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing app...'),
          ],
        ),
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AppInitializer(),
        ),
        GoRoute(
          path: '/school-code',
          builder: (context, state) => const SchoolCodeScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/create-password',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return CreatePasswordScreen(
              mobileNumber: extra?['mobileNumber'] ?? '',
              isPasswordReset: extra?['isPasswordReset'] ?? false,
            );
          },
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
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
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/school-config',
      builder: (context, state) => const SchoolConfigScreen(),
    ),
    GoRoute(
      path: '/track-bus',
      builder: (context, state) => const BusTrackingScreen(),
    ),
    GoRoute(
      path: '/driver-location',
      builder: (context, state) => const DriverLocationScreen(),
    ),
    GoRoute(
      path: '/parent-login',
      builder: (context, state) => const ParentLoginScreen(),
    ),
    GoRoute(
      path: '/parent-registration',
      builder: (context, state) => const ParentRegistrationScreen(),
    ),
            GoRoute(
          path: '/my-classes',
          builder: (context, state) => const MyClassesScreen(),
        ),
        // Enhanced Fee Routes
        GoRoute(
          path: '/fees/overview',
          builder: (context, state) => const FeeOverviewScreen(),
        ),
        GoRoute(
          path: '/fees/summary',
          builder: (context, state) => const TransactionSummaryScreen(),
        ),
        GoRoute(
          path: '/fees/details',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return FeeDetailsScreen(
              categoryName: extra?['categoryName'] ?? '',
              fees: extra?['fees'] ?? [],
            );
          },
        ),
        GoRoute(
          path: '/fees/history',
          builder: (context, state) => const TransactionSummaryScreen(),
        ),
        GoRoute(
          path: '/payment',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return PaymentScreen(
              categoryName: extra?['categoryName'] ?? '',
              amount: extra?['amount'] ?? 0.0,
            );
          },
        ),
  ],
);

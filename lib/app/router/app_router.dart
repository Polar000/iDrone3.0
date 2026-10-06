import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/services/presentation/my_services_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/support/presentation/support_screen.dart';
import '../../features/fields/presentation/map_screen.dart';
import '../../features/bookings/presentation/booking_flow_screen.dart';
import '../../features/tracking/presentation/service_tracking_screen.dart';
import '../../features/reports/presentation/service_report_screen.dart';
import '../../features/operator/presentation/operator_dashboard_screen.dart';
import 'main_shell_screen.dart';

import '../../admin/widgets/admin_shell.dart';
import '../../admin/dashboard/admin_dashboard_screen.dart';
import '../../admin/crops/admin_crops_screen.dart';
import '../../admin/services/admin_services_screen.dart';
import '../../admin/pricing/admin_pricing_screen.dart';
import '../../admin/promotions/admin_promotions_screen.dart';
import '../../admin/bookings/admin_bookings_screen.dart';
import '../../admin/operators/admin_operators_screen.dart';
import '../../admin/drones/admin_drones_screen.dart';
import '../../admin/routes/admin_routes_screen.dart';
import '../../admin/zones/admin_zones_screen.dart';
import '../../admin/branding/admin_branding_screen.dart';
import '../../admin/media/admin_media_screen.dart';
import '../../admin/audit/admin_audit_screen.dart';
import '../../admin/customers/admin_customers_screen.dart';
import '../../admin/settings/admin_settings_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) {
    bool isAuthenticated = false;
    try {
      final session = Supabase.instance.client.auth.currentSession;
      isAuthenticated = session != null;
    } catch (_) {
      isAuthenticated = false;
    }

    final isLoginOrRegister = state.matchedLocation == '/login' || state.matchedLocation == '/register';
    final isPublicRoute = isLoginOrRegister || state.matchedLocation == '/';

    // 1. Unauthenticated users trying to access protected routes -> /login
    if (!isAuthenticated && !isPublicRoute) {
      return '/login';
    }

    // 2. Authenticated users trying to access /login or /register -> /home
    if (isAuthenticated && isLoginOrRegister) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/booking/flow',
      builder: (context, state) => BookingFlowScreen(
        initialService: state.uri.queryParameters['service'],
      ),
    ),
    GoRoute(
      path: '/tracking',
      builder: (context, state) => const ServiceTrackingScreen(),
    ),
    GoRoute(
      path: '/report',
      builder: (context, state) => const ServiceReportScreen(),
    ),
    GoRoute(
      path: '/operator',
      builder: (context, state) => const OperatorDashboardScreen(),
    ),

    // ADMIN SHELL ROUTES
    ShellRoute(
      builder: (context, state, child) => AdminShell(child: child),
      routes: [
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/admin/crops',
          builder: (context, state) => const AdminCropsScreen(),
        ),
        GoRoute(
          path: '/admin/services',
          builder: (context, state) => const AdminServicesScreen(),
        ),
        GoRoute(
          path: '/admin/pricing',
          builder: (context, state) => const AdminPricingScreen(),
        ),
        GoRoute(
          path: '/admin/promotions',
          builder: (context, state) => const AdminPromotionsScreen(),
        ),
        GoRoute(
          path: '/admin/bookings',
          builder: (context, state) => const AdminBookingsScreen(),
        ),
        GoRoute(
          path: '/admin/operators',
          builder: (context, state) => const AdminOperatorsScreen(),
        ),
        GoRoute(
          path: '/admin/drones',
          builder: (context, state) => const AdminDronesScreen(),
        ),
        GoRoute(
          path: '/admin/routes',
          builder: (context, state) => const AdminRoutesScreen(),
        ),
        GoRoute(
          path: '/admin/zones',
          builder: (context, state) => const AdminZonesScreen(),
        ),
        GoRoute(
          path: '/admin/branding',
          builder: (context, state) => const AdminBrandingScreen(),
        ),
        GoRoute(
          path: '/admin/media',
          builder: (context, state) => const AdminMediaScreen(),
        ),
        GoRoute(
          path: '/admin/audit',
          builder: (context, state) => const AdminAuditScreen(),
        ),
        GoRoute(
          path: '/admin/customers',
          builder: (context, state) => const AdminCustomersScreen(),
        ),
        GoRoute(
          path: '/admin/settings',
          builder: (context, state) => const AdminSettingsScreen(),
        ),
      ],
    ),

    // CUSTOMER MOBILE SHELL ROUTES
    ShellRoute(
      builder: (context, state, child) => MainShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/my-services',
          builder: (context, state) => const MyServicesScreen(),
        ),
        GoRoute(
          path: '/map',
          builder: (context, state) => const MapScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/support',
      builder: (context, state) => const SupportScreen(),
    ),
  ],
);

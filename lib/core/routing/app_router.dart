import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/main/presentation/screens/main_screen.dart';
import '../../features/news/presentation/screens/news_screen.dart';
import '../../features/news/presentation/screens/news_detail_screen.dart';
import '../../features/news/domain/entities/news.dart';
import '../../features/projects/presentation/screens/projects_screen.dart';
import '../../features/projects/presentation/screens/project_detail_screen.dart';
import '../../features/projects/domain/entities/project.dart';
import '../../features/tuyen_dung/presentation/screens/tuyen_dung_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/thu_vien/presentation/screens/thu_vien_screen.dart';
import '../../features/thu_vien/presentation/screens/photo_view_screen.dart';
import '../../features/thu_vien/domain/entities/thu_vien.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/utilities/presentation/screens/loan_calculator_screen.dart';
import '../../features/utilities/presentation/screens/feng_shui_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  static final goRouter = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/projects',
                builder: (context, state) => const ProjectsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/news',
                builder: (context, state) => const NewsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/gallery',
                builder: (context, state) => const ThuVienScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/recruitment',
                builder: (context, state) => const RecruitmentScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/projects/detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final project = state.extra as Project;
          return ProjectDetailScreen(project: project);
        },
      ),
      GoRoute(
        path: '/news/detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final news = state.extra as News;
          return NewsDetailScreen(news: news);
        },
      ),
      GoRoute(
        path: '/gallery/detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final thuVien = state.extra as ThuVien;
          return PhotoViewScreen(thuVien: thuVien);
        },
      ),
      GoRoute(
        path: '/search',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/utilities/loan',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoanCalculatorScreen(),
      ),
      GoRoute(
        path: '/utilities/feng-shui',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FengShuiScreen(),
      ),
    ],
  );
}

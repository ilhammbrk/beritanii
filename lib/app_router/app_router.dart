import 'package:beritaini/layouts/main_layout.dart';
import 'package:beritaini/models/news_model.dart';
import 'package:beritaini/screens/auth/login_screen.dart';
import 'package:beritaini/screens/auth/register_screen.dart';
import 'package:beritaini/screens/bookmark/bookmark_screen.dart';
import 'package:beritaini/screens/create-news/create_news_screen.dart';
import 'package:beritaini/screens/edit-news/edit_news_screen.dart';
import 'package:beritaini/screens/home/home_screen.dart';
import 'package:beritaini/screens/introductions/introductions_screen.dart';
import 'package:beritaini/screens/my-news/my_news_screen.dart';
import 'package:beritaini/screens/news/news_detail_screen.dart';
import 'package:beritaini/screens/news/news_screen.dart';
import 'package:beritaini/screens/profile/profile_screen.dart';
import 'package:beritaini/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: '/introductions',
        name: 'introductions',
        builder: (context, state) => const IntroductionsScreen(),
      ),

      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(currentPath: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/news',
            name: 'news',
            builder: (context, state) => const NewsScreen(),
          ),
          GoRoute(
            path: '/bookmark',
            name: 'bookmark',
            builder: (context, state) => const BookmarkScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      GoRoute(
        path: '/news/detail/:id',
        name: 'news-detail',
        builder: (context, state) {
          final news = state.extra as News;
          return NewsDetailScreen(news: news);
        },
      ),
      GoRoute(
        path: '/my-news',
        name: 'my-news',
        builder: (context, state) => const MyNewsScreen(),
      ),

      GoRoute(
        path: '/create-news',
        name: 'create-news',
        builder: (context, state) => const CreateNewsScreen(),
      ),

      GoRoute(
        path: '/edit-news/:id',
        name: 'edit-news',
        builder: (context, state) {
          final news = state.extra as News;
          return EditNewsScreen(news: news);
        },
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Halaman tidak ditemukan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    ),
    debugLogDiagnostics: true,
  );
}

extension AppRouterExtension on BuildContext {
  void goToSplash() => go('/splash');
  void goToIntroductions() => go('/introductions');
  void goToLogin() => go('/login');
  void goToRegister() => go('/register');
  void goToHome() => go('/home');
  void goToNews() => go('/news');
  void goToNewsDetail(String newsId) => go('/news/detail/$newsId');
  void goToProfile() => go('/profile');
  void goToBookmark() => go('/bookmark');
  void goToMyNews() => go('/my-news');
  void goToCreateNews() => go('/create-news');
  void goToEditNews(String newsId) => go('/edit-news/$newsId');
  void pushLogin() => push('/login');
  void pushRegister() => push('/register');
  void pushCreateNews() => push('/create-news');
  void pushEditNews(String newsId) => push('/edit-news/$newsId');
}

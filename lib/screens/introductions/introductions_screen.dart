import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../services/shared_preferences_service.dart';

class IntroductionsScreen extends StatefulWidget {
  const IntroductionsScreen({super.key});

  @override
  State<IntroductionsScreen> createState() => _IntroductionsScreenState();
}

class _IntroductionsScreenState extends State<IntroductionsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<IntroductionItem> _introItems = [
    IntroductionItem(
      icon: Icons.newspaper_rounded,
      title: 'Berita Terkini',
      description:
          'Dapatkan informasi berita terbaru dan terpercaya dari berbagai sumber',
      color: Colors.blue,
    ),
    IntroductionItem(
      icon: Icons.bookmark_rounded,
      title: 'Simpan Favorit',
      description: 'Simpan artikel menarik dan baca kapan saja Anda mau',
      color: Colors.green,
    ),
    IntroductionItem(
      icon: Icons.create_rounded,
      title: 'Buat Berita',
      description: 'Bagikan berita dan informasi penting untuk komunitas',
      color: Colors.orange,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _introItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishIntroduction();
    }
  }

  void _finishIntroduction() async {
    await SharedPreferencesService.setHasSeenIntroduction(true);

    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _finishIntroduction,
                    child: Text(
                      'Lewati',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _introItems.length,
                itemBuilder: (context, index) {
                  final item = _introItems[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Icon(
                            item.icon,
                            size: 60.sp,
                            color: item.color,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _introItems.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        width: _currentPage == index ? 24.w : 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.blue.shade600
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage == _introItems.length - 1
                            ? 'Mulai Sekarang'
                            : 'Selanjutnya',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class IntroductionItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  IntroductionItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

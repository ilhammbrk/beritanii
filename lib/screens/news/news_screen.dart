import 'package:beritaini/models/news_model.dart';
import 'package:beritaini/services/news_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  final List<String> _categories = [
    'Semua',
    'Politik',
    'Ekonomi',
    'Teknologi',
    'Olahraga',
    'Kesehatan',
    'Hiburan',
    'Pendidikan',
  ];

  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  List<News> _newsList = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNews();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _currentPage < _totalPages) {
      _loadMoreNews();
    }
  }

  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _currentPage = 1;
    });

    try {
      final response = await _newsService.getPublishedNews(
        page: _currentPage,
        limit: 10,
        category: _selectedCategory == 'Semua'
            ? null
            : _selectedCategory.toLowerCase(),
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      if (mounted) {
        setState(() {
          _newsList = response.data;
          _totalPages = response.pagination?.totalPages ?? 1;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _loadMoreNews() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final response = await _newsService.getPublishedNews(
        page: nextPage,
        limit: 10,
        category: _selectedCategory == 'Semua'
            ? null
            : _selectedCategory.toLowerCase(),
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );

      if (mounted) {
        setState(() {
          _newsList.addAll(response.data);
          _currentPage = nextPage;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat berita tambahan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _performSearch() {
    _searchQuery = _searchController.text.trim();
    _fetchNews();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Berita',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border, color: Colors.grey.shade700),
            onPressed: () {
              context.go('/bookmark');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategorySelector(),
          Expanded(
            child: _hasError
                ? _buildErrorView()
                : _isLoading
                ? _buildLoadingView()
                : _buildNewsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari berita...',
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.blue.shade400),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onSubmitted: (_) => _performSearch(),
              textInputAction: TextInputAction.search,
            ),
          ),
          SizedBox(width: 8.w),
          ElevatedButton(
            onPressed: _performSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Cari',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 50.h,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
              _fetchNews();
            },
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade600 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? Colors.blue.shade600
                      : Colors.grey.shade300,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            'Gagal memuat berita',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: _fetchNews,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 120.h,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNewsList() {
    if (_newsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 60.sp,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16.h),
            Text(
              'Tidak ada berita yang ditemukan',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchNews,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(16.w),
        itemCount: _newsList.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _newsList.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.h),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final news = _newsList[index];
          return _buildNewsCard(news);
        },
      ),
    );
  }

  Widget _buildNewsCard(News news) {
    return GestureDetector(
      onTap: () {
        context.go('/news/detail/${news.id}', extra: news);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              child: news.featuredImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: news.featuredImageUrl!,
                      height: 180.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[300], height: 180.h),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        height: 180.h,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[500],
                          size: 40.sp,
                        ),
                      ),
                    )
                  : Container(
                      height: 180.h,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[500],
                        size: 40.sp,
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (news.category != null)
                    Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        news.category!,
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Text(
                    news.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade800,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  if (news.summary != null)
                    Text(
                      news.summary!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.grey.shade500,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        news.authorName ?? 'Anonim',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Icon(
                        Icons.calendar_today,
                        color: Colors.grey.shade500,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatDate(news.publishedAt ?? news.createdAt),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.visibility,
                        color: Colors.grey.shade500,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${news.viewCount}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} menit yang lalu';
      }
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year;
      return '$day/$month/$year';
    }
  }
}

import 'package:beritaini/models/news_model.dart';
import 'package:beritaini/services/news_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class NewsDetailScreen extends StatefulWidget {
  final News news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final NewsService _newsService = NewsService();
  bool _isLoading = true;
  bool _isBookmarked = false;
  News? _fullNewsData;
  List<News> _relatedNews = [];

  @override
  void initState() {
    super.initState();
    _loadNewsDetails();
  }

  Future<void> _loadNewsDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newsResponse = await _newsService.getNewsBySlug(widget.news.slug);
      final relatedResponse = await _newsService.getPublishedNews(
        limit: 5,
        category: newsResponse.data.category,
      );

      if (mounted) {
        setState(() {
          _fullNewsData = newsResponse.data;
          _relatedNews = relatedResponse.data
              .where((news) => news.id != widget.news.id)
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Gagal memuat detail berita: ${e.toString()}');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked
              ? 'Berita disimpan ke bookmark'
              : 'Berita dihapus dari bookmark',
        ),
        backgroundColor: _isBookmarked ? Colors.green : Colors.grey.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final news = _fullNewsData ?? widget.news;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingView()
            : CustomScrollView(
                slivers: [
                  _buildAppBar(news),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNewsHeader(news),
                        _buildNewsContent(news),
                        if (_relatedNews.isNotEmpty) _buildRelatedNews(),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: _buildShareButton(),
    );
  }

  Widget _buildLoadingView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 40.h,
              width: 250.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 20.h,
              width: 150.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          for (int i = 0; i < 10; i++) ...[
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 12.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(News news) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back,
            color: Colors.grey.shade800,
            size: 20.sp,
          ),
        ),
        onPressed: () => context.go("/home"),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked
                  ? Colors.blue.shade600
                  : Colors.grey.shade800,
              size: 20.sp,
            ),
          ),
          onPressed: _toggleBookmark,
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildNewsHeader(News news) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (news.category != null)
            Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                news.category!,
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Text(
            news.title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
              height: 1.3,
            ),
          ),
          SizedBox(height: 16.h),
          if (news.featuredImageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: news.featuredImageUrl!,
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  width: double.infinity,
                  height: 200.h,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  width: double.infinity,
                  height: 200.h,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[500],
                    size: 40.sp,
                  ),
                ),
              ),
            ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: news.authorAvatar != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18.r),
                        child: CachedNetworkImage(
                          imageUrl: news.authorAvatar!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Icon(
                            Icons.person,
                            color: Colors.grey.shade400,
                            size: 20.sp,
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            color: Colors.grey.shade400,
                            size: 20.sp,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: Colors.grey.shade400,
                        size: 20.sp,
                      ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.authorName ?? 'Anonim',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      _formatDate(news.publishedAt ?? news.createdAt),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.visibility,
                    color: Colors.grey.shade600,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${news.viewCount}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewsContent(News news) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (news.summary != null) ...[
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Text(
                news.summary!,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
          if (news.content != null)
            Text(
              news.content!,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey.shade800,
                height: 1.6,
              ),
            )
          else
            Text(
              'Konten berita tidak tersedia.',
              style: TextStyle(
                fontSize: 16.sp,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
          SizedBox(height: 24.h),
          if (news.tags.isNotEmpty) ...[
            Text(
              'Tags',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: news.tags.map((tag) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    '#$tag',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRelatedNews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: Text(
            'Berita Terkait',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _relatedNews.length,
            itemBuilder: (context, index) {
              final news = _relatedNews[index];
              return _buildRelatedNewsCard(news);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedNewsCard(News news) {
    return GestureDetector(
      onTap: () {
        context.go('/news/detail/${news.id}', extra: news);
      },
      child: Container(
        width: 160.w,
        margin: EdgeInsets.only(right: 16.w),
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
            // Gambar berita
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              child: news.featuredImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: news.featuredImageUrl!,
                      height: 100.h,
                      width: 160.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[300]),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[500],
                          size: 24.sp,
                        ),
                      ),
                    )
                  : Container(
                      height: 100.h,
                      width: 160.w,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[500],
                        size: 24.sp,
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Spacer(),
                    Text(
                      _formatDate(news.publishedAt ?? news.createdAt),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.blue.shade600,
      elevation: 2,
      child: const Icon(Icons.share, color: Colors.white),
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

import 'package:beritaini/models/news_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  late List<News> _bookmarkedNews;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarkedNews();
  }

  Future<void> _loadBookmarkedNews() async {
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _bookmarkedNews = _getDummyBookmarkedNews();
        _isLoading = false;
      });
    }
  }

  List<News> _getDummyBookmarkedNews() {
    return [
      News(
        id: '1',
        title:
            'Indonesia Berhasil Menurunkan Emisi Karbon Sebesar 20% Tahun Ini',
        slug: 'indonesia-berhasil-menurunkan-emisi-karbon',
        summary:
            'Upaya pemerintah dalam mengurangi emisi karbon menunjukkan hasil positif dengan penurunan 20% dibandingkan tahun lalu.',
        content:
            'Jakarta - Kementerian Lingkungan Hidup dan Kehutanan (KLHK) melaporkan bahwa Indonesia berhasil menurunkan emisi karbon sebesar 20% pada tahun ini dibandingkan dengan tahun sebelumnya. Pencapaian ini merupakan hasil dari berbagai program penghijauan, pengurangan penggunaan bahan bakar fosil, dan peningkatan energi terbarukan di berbagai sektor.\n\nMenteri KLHK menyatakan bahwa pencapaian ini melampaui target yang ditetapkan dalam komitmen Indonesia pada Perjanjian Paris. "Ini adalah bukti nyata bahwa Indonesia serius dalam mengatasi perubahan iklim dan berkontribusi pada upaya global untuk mengurangi pemanasan global," ujarnya dalam konferensi pers kemarin.\n\nBeberapa program unggulan yang berkontribusi pada pencapaian ini termasuk rehabilitasi hutan mangrove seluas 600 ribu hektar, peningkatan penggunaan energi surya di gedung-gedung pemerintah, dan implementasi kebijakan kendaraan listrik di beberapa kota besar.',
        featuredImageUrl:
            'https://images.unsplash.com/photo-1532601224476-15c79f2f7a51',
        authorId: 'author1',
        category: 'Lingkungan',
        tags: ['lingkungan', 'emisi karbon', 'perubahan iklim'],
        isPublished: true,
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        viewCount: 1250,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        authorName: 'Dian Sastrowardoyo',
        authorBio: 'Jurnalis lingkungan hidup',
        authorAvatar: 'https://randomuser.me/api/portraits/women/44.jpg',
      ),
      News(
        id: '2',
        title: 'Startup Teknologi Indonesia Raih Pendanaan 50 Juta Dolar AS',
        slug: 'startup-teknologi-indonesia-raih-pendanaan',
        summary:
            'Sebuah startup teknologi finansial asal Indonesia berhasil mendapatkan pendanaan seri B senilai 50 juta dolar AS dari investor global.',
        content:
            'Jakarta - PayNow, startup teknologi finansial (fintech) asal Indonesia, berhasil mendapatkan pendanaan seri B senilai 50 juta dolar AS yang dipimpin oleh East Ventures, dengan partisipasi dari Sequoia Capital dan Softbank Ventures Asia. Pendanaan ini akan digunakan untuk ekspansi ke negara-negara Asia Tenggara lainnya dan pengembangan produk baru.\n\nDidirikan pada 2019, PayNow telah menjadi salah satu platform pembayaran digital terkemuka di Indonesia dengan lebih dari 10 juta pengguna aktif bulanan. Startup ini menawarkan berbagai layanan keuangan, termasuk dompet digital, transfer uang, pembayaran tagihan, dan pinjaman mikro untuk usaha kecil dan menengah.\n\n"Pendanaan ini merupakan pengakuan atas pertumbuhan pesat yang kami capai dalam tiga tahun terakhir dan potensi pasar yang masih sangat besar di Indonesia dan Asia Tenggara," kata CEO PayNow dalam keterangan resminya.',
        featuredImageUrl:
            'https://images.unsplash.com/photo-1559526324-593bc073d938',
        authorId: 'author2',
        category: 'Teknologi',
        tags: ['startup', 'fintech', 'pendanaan'],
        isPublished: true,
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        viewCount: 3420,
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        authorName: 'Reza Rahadian',
        authorBio: 'Editor Teknologi',
        authorAvatar: 'https://randomuser.me/api/portraits/men/22.jpg',
      ),
      News(
        id: '3',
        title: 'Tim Basket Indonesia Lolos ke Semifinal Kejuaraan Asia',
        slug: 'tim-basket-indonesia-lolos-semifinal',
        summary:
            'Tim nasional basket Indonesia berhasil mengalahkan Filipina dan lolos ke semifinal Kejuaraan Basket Asia untuk pertama kalinya.',
        content:
            'Manila - Tim nasional basket Indonesia mencatatkan sejarah baru setelah berhasil mengalahkan Filipina dengan skor 88-82 dalam pertandingan perempat final Kejuaraan Basket Asia 2023. Kemenangan ini mengantar Indonesia ke semifinal untuk pertama kalinya dalam sejarah keikutsertaan di kejuaraan ini.\n\nPertandingan yang berlangsung sengit di Mall of Asia Arena, Manila, menyaksikan timnas Indonesia tampil luar biasa dengan dipimpin oleh naturalisasi Marques Bolden yang menyumbang 24 poin dan 12 rebound. Pemain lokal Abraham Damar juga tampil gemilang dengan 18 poin, termasuk empat tembakan tiga angka.\n\n"Ini adalah momen bersejarah bagi basket Indonesia. Kami bermain dengan sepenuh hati dan tidak gentar menghadapi Filipina yang merupakan salah satu kekuatan basket di Asia," ujar pelatih kepala timnas Indonesia setelah pertandingan.',
        featuredImageUrl:
            'https://images.unsplash.com/photo-1546519638-68e109498ffc',
        authorId: 'author3',
        category: 'Olahraga',
        tags: ['basket', 'timnas', 'kejuaraan asia'],
        isPublished: true,
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        viewCount: 5670,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        authorName: 'Nicholas Saputra',
        authorBio: 'Jurnalis Olahraga Senior',
        authorAvatar: 'https://randomuser.me/api/portraits/men/42.jpg',
      ),
      News(
        id: '4',
        title: 'Festival Kuliner Nusantara Digelar di 10 Kota Besar',
        slug: 'festival-kuliner-nusantara',
        summary:
            'Kementerian Pariwisata dan Ekonomi Kreatif akan menggelar Festival Kuliner Nusantara di 10 kota besar Indonesia mulai bulan depan.',
        content:
            'Jakarta - Kementerian Pariwisata dan Ekonomi Kreatif (Kemenparekraf) akan menggelar Festival Kuliner Nusantara di 10 kota besar Indonesia mulai bulan depan. Festival ini bertujuan untuk mempromosikan kekayaan kuliner Indonesia dan mendukung pemulihan sektor pariwisata pasca pandemi.\n\nFestival akan diselenggarakan secara bergiliran di Jakarta, Bandung, Yogyakarta, Surabaya, Denpasar, Makassar, Medan, Palembang, Pontianak, dan Manado dengan menampilkan lebih dari 100 kuliner khas dari berbagai daerah di Indonesia.\n\n"Festival Kuliner Nusantara ini merupakan bagian dari strategi kami untuk memperkenalkan kekayaan kuliner Indonesia tidak hanya kepada masyarakat lokal tetapi juga wisatawan mancanegara," kata Menteri Pariwisata dan Ekonomi Kreatif dalam siaran persnya.',
        featuredImageUrl:
            'https://images.unsplash.com/photo-1563245372-f21724e3856d',
        authorId: 'author4',
        category: 'Kuliner',
        tags: ['kuliner', 'festival', 'pariwisata'],
        isPublished: true,
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        viewCount: 2890,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        authorName: 'Raline Shah',
        authorBio: 'Jurnalis Kuliner & Gaya Hidup',
        authorAvatar: 'https://randomuser.me/api/portraits/women/33.jpg',
      ),
      News(
        id: '5',
        title: 'Peneliti Indonesia Temukan Spesies Baru Kupu-kupu di Papua',
        slug: 'peneliti-indonesia-temukan-spesies-baru',
        summary:
            'Tim peneliti dari LIPI berhasil menemukan spesies baru kupu-kupu endemik Papua yang diberi nama Ornithoptera paradisea indonesiana.',
        content:
            'Jayapura - Tim peneliti dari Lembaga Ilmu Pengetahuan Indonesia (LIPI) berhasil menemukan spesies baru kupu-kupu endemik Papua yang diberi nama Ornithoptera paradisea indonesiana. Penemuan ini menambah daftar kekayaan hayati Indonesia yang sudah sangat beragam.\n\nKupu-kupu tersebut memiliki sayap dengan rentang hingga 20 cm dengan warna dominan hitam dan hijau metalik yang mencolok. Spesies ini ditemukan di kawasan hutan hujan dataran rendah di Pegunungan Cyclops, Papua.\n\n"Penemuan ini sangat penting bagi ilmu pengetahuan dan konservasi keanekaragaman hayati Indonesia. Ornithoptera paradisea indonesiana memiliki karakteristik unik yang membedakannya dari spesies kupu-kupu lain di genus yang sama," ujar ketua tim peneliti dari LIPI.',
        featuredImageUrl:
            'https://images.unsplash.com/photo-1527720219773-6d1c9d3d8591',
        authorId: 'author5',
        category: 'Sains',
        tags: ['penelitian', 'biodiversitas', 'papua'],
        isPublished: true,
        publishedAt: DateTime.now().subtract(const Duration(days: 7)),
        viewCount: 1870,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
        authorName: 'Chelsea Islan',
        authorBio: 'Jurnalis Sains & Lingkungan',
        authorAvatar: 'https://randomuser.me/api/portraits/women/66.jpg',
      ),
    ];
  }

  void _removeBookmark(String newsId) {
    setState(() {
      _bookmarkedNews.removeWhere((news) => news.id == newsId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Berita dihapus dari bookmark'),
        backgroundColor: Colors.grey.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Bookmark Saya',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ),
      body: _isLoading
          ? _buildLoadingView()
          : _bookmarkedNews.isEmpty
          ? _buildEmptyView()
          : _buildBookmarkList(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blue.shade600),
          SizedBox(height: 16.h),
          Text(
            'Memuat bookmark...',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80.sp, color: Colors.grey.shade400),
          SizedBox(height: 16.h),
          Text(
            'Belum ada berita yang disimpan',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tambahkan berita favorit Anda ke bookmark\nuntuk membacanya nanti',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () => context.go('/news'),
            icon: const Icon(Icons.article_outlined),
            label: const Text('Jelajahi Berita'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _bookmarkedNews.length,
      itemBuilder: (context, index) {
        final news = _bookmarkedNews[index];
        return _buildBookmarkCard(news);
      },
    );
  }

  Widget _buildBookmarkCard(News news) {
    return Dismissible(
      key: Key(news.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 28.sp),
      ),
      onDismissed: (direction) {
        _removeBookmark(news.id);
      },
      child: GestureDetector(
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
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
                child: news.featuredImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: news.featuredImageUrl!,
                        height: 100.h,
                        width: 100.w,
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
                        width: 100.w,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[500],
                          size: 24.sp,
                        ),
                      ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  height: 120.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (news.category != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            news.category!,
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      SizedBox(height: 4.h),
                      Expanded(
                        child: Text(
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
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey.shade500,
                            size: 12.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _formatDate(news.publishedAt ?? news.createdAt),
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.bookmark, color: Colors.blue.shade600),
                onPressed: () => _removeBookmark(news.id),
              ),
            ],
          ),
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

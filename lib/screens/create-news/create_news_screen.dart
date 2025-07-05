import 'package:beritaini/models/news_model.dart';
import 'package:beritaini/services/news_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CreateNewsScreen extends StatefulWidget {
  const CreateNewsScreen({super.key});

  @override
  State<CreateNewsScreen> createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(
    text: 'Perkembangan Teknologi AI di Indonesia Tahun 2024',
  );
  final _summaryController = TextEditingController(
    text:
        'Indonesia menunjukkan perkembangan pesat dalam adopsi teknologi kecerdasan buatan (AI) di berbagai sektor pada tahun 2024.',
  );
  final _contentController = TextEditingController(
    text:
        'Jakarta - Dalam beberapa tahun terakhir, Indonesia telah menunjukkan perkembangan yang signifikan dalam adopsi teknologi kecerdasan buatan (Artificial Intelligence/AI). Tahun 2024 menjadi tahun yang penting bagi perkembangan AI di Indonesia dengan berbagai inovasi dan implementasi di berbagai sektor.\n\nMenurut data dari Kementerian Komunikasi dan Informatika, investasi di bidang AI di Indonesia telah meningkat sebesar 45% dibandingkan tahun sebelumnya. Peningkatan ini didorong oleh kesadaran perusahaan lokal akan pentingnya transformasi digital dan otomatisasi untuk meningkatkan efisiensi operasional.\n\nBeberapa sektor yang menunjukkan adopsi AI paling pesat adalah perbankan, e-commerce, kesehatan, dan pertanian. Di sektor perbankan, implementasi chatbot dan sistem deteksi fraud berbasis AI telah membantu meningkatkan layanan nasabah dan keamanan transaksi. Sementara di sektor kesehatan, teknologi AI digunakan untuk membantu diagnosis penyakit dan mengoptimalkan manajemen rumah sakit.\n\n"Indonesia memiliki potensi besar untuk menjadi pemimpin dalam adopsi AI di Asia Tenggara," ujar Dr. Budi Santoso, pakar teknologi dari Institut Teknologi Bandung. "Dengan populasi yang besar dan tingkat penetrasi smartphone yang tinggi, Indonesia memiliki data yang melimpah untuk pengembangan model AI yang efektif."\n\nPemerintah Indonesia juga telah menunjukkan dukungan terhadap perkembangan AI melalui berbagai kebijakan dan inisiatif. Salah satunya adalah peluncuran Strategi Nasional Kecerdasan Artifisial yang bertujuan untuk mempercepat adopsi AI di berbagai sektor dan mendorong pengembangan talent lokal di bidang ini.\n\nMeskipun demikian, masih ada tantangan yang perlu diatasi, seperti kesenjangan digital, infrastruktur yang belum merata, dan kebutuhan akan regulasi yang lebih jelas terkait penggunaan dan perlindungan data dalam implementasi AI.\n\nKe depannya, diharapkan kolaborasi antara pemerintah, sektor swasta, dan akademisi dapat terus mendorong perkembangan ekosistem AI di Indonesia, sehingga teknologi ini dapat memberikan manfaat yang lebih luas bagi masyarakat dan ekonomi nasional.',
  );
  final _featuredImageUrlController = TextEditingController(
    text: 'https://images.unsplash.com/photo-1677442136019-21780ecad995',
  );
  final _categoryController = TextEditingController(text: 'Teknologi');
  final _tagsController = TextEditingController(
    text: 'ai, teknologi, indonesia, digital',
  );

  final NewsService _newsService = NewsService();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _featuredImageUrlController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _createNews() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      final request = CreateNewsRequest(
        title: _titleController.text,
        summary: _summaryController.text,
        content: _contentController.text,
        featuredImageUrl: _featuredImageUrlController.text.isNotEmpty
            ? _featuredImageUrlController.text
            : null,
        category: _categoryController.text,
        tags: tags,
        isPublished: true,
      );

      final response = await _newsService.createNews(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Artikel berhasil dipublikasikan'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        context.go('/my-news');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mempublikasikan artikel: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Buat Artikel Baru',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blue.shade600),
                  SizedBox(height: 16.h),
                  Text(
                    'Mempublikasikan artikel...',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Judul Artikel'),
                    _buildTextField(
                      controller: _titleController,
                      hintText: 'Masukkan judul artikel',
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Judul tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),

                    _buildSectionTitle('Ringkasan'),
                    _buildTextField(
                      controller: _summaryController,
                      hintText: 'Masukkan ringkasan artikel (1-2 kalimat)',
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ringkasan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),

                    _buildSectionTitle('Konten'),
                    _buildTextField(
                      controller: _contentController,
                      hintText: 'Masukkan konten artikel',
                      maxLines: 15,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konten tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),

                    _buildSectionTitle('URL Gambar Utama (Opsional)'),
                    _buildTextField(
                      controller: _featuredImageUrlController,
                      hintText: 'Masukkan URL gambar utama',
                    ),
                    if (_featuredImageUrlController.text.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            _featuredImageUrlController.text,
                            height: 200.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 200.h,
                                  width: double.infinity,
                                  color: Colors.grey.shade300,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Gambar tidak valid',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ),
                    SizedBox(height: 20.h),

                    _buildSectionTitle('Kategori'),
                    _buildTextField(
                      controller: _categoryController,
                      hintText: 'Masukkan kategori artikel',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kategori tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),

                    _buildSectionTitle('Tags (pisahkan dengan koma)'),
                    _buildTextField(
                      controller: _tagsController,
                      hintText: 'Contoh: teknologi, pendidikan, indonesia',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tags tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40.h),

                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createNews,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                        ),
                        child: Text(
                          'Publikasikan Artikel',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
      validator: validator,
    );
  }
}

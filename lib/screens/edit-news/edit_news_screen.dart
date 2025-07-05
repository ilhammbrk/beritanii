import 'package:beritaini/models/news_model.dart';
import 'package:beritaini/services/news_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EditNewsScreen extends StatefulWidget {
  final News news;

  const EditNewsScreen({super.key, required this.news});

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _summaryController;
  late final TextEditingController _contentController;
  late final TextEditingController _featuredImageUrlController;
  late final TextEditingController _categoryController;
  late final TextEditingController _tagsController;

  final NewsService _newsService = NewsService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.news.title);
    _summaryController = TextEditingController(text: widget.news.summary);
    _contentController = TextEditingController(text: widget.news.content);
    _featuredImageUrlController = TextEditingController(
      text: widget.news.featuredImageUrl,
    );
    _categoryController = TextEditingController(text: widget.news.category);
    _tagsController = TextEditingController(text: widget.news.tags.join(', '));
  }

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

  Future<void> _updateNews() async {
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

      final request = UpdateNewsRequest(
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

      final response = await _newsService.updateNews(widget.news.id, request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Artikel berhasil diperbarui'),
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
            content: Text('Gagal memperbarui artikel: ${e.toString()}'),
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
          'Edit Artikel',
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
                    'Menyimpan perubahan...',
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
                        onPressed: _isLoading ? null : _updateNews,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                        ),
                        child: Text(
                          'Simpan Perubahan',
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

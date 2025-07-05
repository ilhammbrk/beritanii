import 'package:beritaini/models/auth_model.dart';
import 'package:beritaini/services/auth_service.dart';
import 'package:beritaini/services/shared_preferences_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  Author? _profileData;
  Map<String, String?> _localUserData = {};

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    _localUserData = SharedPreferencesService.getUserData();

    try {
      final token = SharedPreferencesService.getToken();

      if (token == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Sesi login tidak ditemukan';
        });
        return;
      }

      final response = await _authService.getProfile(token);

      if (mounted) {
        setState(() {
          _profileData = response.data;
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

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Konfirmasi Logout',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await SharedPreferencesService.logout();
              if (mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Profil Saya',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.grey.shade700),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingView()
          : _hasError
          ? _buildErrorView()
          : _buildProfileView(),
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
            'Memuat profil...',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
          ),
        ],
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
            'Gagal memuat profil',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: _loadProfileData,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    final author = _profileData;
    final name = author?.fullName ?? _localUserData['name'] ?? 'Pengguna';
    final email =
        author?.email ?? _localUserData['email'] ?? 'Email tidak tersedia';
    final bio = author?.bio ?? _localUserData['bio'] ?? 'Belum ada bio';
    final avatarUrl = author?.avatarUrl ?? _localUserData['avatar'];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          _buildProfileHeader(name, email, avatarUrl),
          SizedBox(height: 24.h),
          _buildBioSection(bio),
          SizedBox(height: 24.h),
          _buildActionButtons(),
          SizedBox(height: 24.h),
          _buildAccountInfoSection(),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email, String? avatarUrl) {
    return Column(
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60.w),
            child: avatarUrl != null
                ? CachedNetworkImage(
                    imageUrl: avatarUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade300,
                      child: Icon(
                        Icons.person,
                        size: 60.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade300,
                      child: Icon(
                        Icons.person,
                        size: 60.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  )
                : Icon(Icons.person, size: 60.sp, color: Colors.grey.shade400),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          email,
          style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildBioSection(String bio) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
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
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20.sp,
                color: Colors.blue.shade600,
              ),
              SizedBox(width: 8.w),
              Text(
                'Bio',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            bio,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          icon: Icons.article_outlined,
          title: 'Artikel Saya',
          subtitle: 'Lihat dan kelola artikel yang telah Anda tulis',
          onTap: () => context.go('/my-news'),
        ),
        SizedBox(height: 12.h),
        _buildActionButton(
          icon: Icons.edit_outlined,
          title: 'Edit Profil',
          subtitle: 'Ubah informasi profil dan foto Anda',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Fitur ini belum tersedia'),
                backgroundColor: Colors.grey.shade700,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
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
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: Colors.blue.shade600, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
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
          Row(
            children: [
              Icon(Icons.security, size: 20.sp, color: Colors.blue.shade600),
              SizedBox(width: 8.w),
              Text(
                'Informasi Akun',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInfoItem(
            title: 'Status Akun',
            value: _profileData?.isActive == true ? 'Aktif' : 'Tidak Aktif',
            valueColor: _profileData?.isActive == true
                ? Colors.green
                : Colors.red,
          ),
          SizedBox(height: 12.h),
          _buildInfoItem(
            title: 'Tanggal Bergabung',
            value: _formatDate(_profileData?.createdAt),
          ),
          SizedBox(height: 12.h),
          _buildInfoItem(
            title: 'Terakhir Diperbarui',
            value: _formatDate(_profileData?.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tidak tersedia';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    return '$day/$month/$year';
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/theme.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/social_controller.dart';
import '../../widgets/common_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _imagePicker = ImagePicker();
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = Get.find<AuthController>().user.value;
    if (user != null) {
      _nameController.text = user.displayName;
      _bioController.text = user.bio ?? '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final social = Get.find<SocialController>();
        social.startListeningToFollowers(user.uid);
        social.startListeningToFollowing(user.uid);
        social.startListeningToUserPosts(user.uid);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    if (pickedFile != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo updated')),
      );
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      await Get.find<AuthController>().updateProfile(
            displayName: _nameController.text.trim(),
            bio: _bioController.text.trim(),
          );
      if (mounted) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close_rounded : Icons.edit_rounded),
            onPressed: () => setState(() => _isEditing = !_isEditing),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Logout', style: TextStyle(color: AppTheme.error)),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await Get.find<AuthController>().logout();
                Get.offAllNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        final auth = Get.find<AuthController>();
        final social = Get.find<SocialController>();
        final user = auth.user.value;
        if (user == null) return const LoadingIndicator();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: _isEditing ? _pickImage : null,
                child: Stack(
                  children: [
                    UserAvatar(
                      photoURL: user.photoURL,
                      displayName: user.displayName,
                      radius: 44,
                      isOnline: user.isOnline,
                      showOnlineIndicator: true,
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.displayName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              if (user.bio != null && user.bio!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(user.bio!, style: const TextStyle(color: AppTheme.textSecondary)),
                ),
              const SizedBox(height: 20),

              Row(
                children: [
                  _buildStat(social.userPosts.length.toString(), 'Posts'),
                  Container(width: 1, height: 40, color: AppTheme.dividerColor),
                  _buildStat(social.followersCount.value.toString(), 'Followers'),
                  Container(width: 1, height: 40, color: AppTheme.dividerColor),
                  _buildStat(social.followingCount.value.toString(), 'Following'),
                ],
              ),
              const SizedBox(height: 24),

              if (_isEditing) ...[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    hintText: 'Tell us about yourself...',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  child: _isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Save Changes'),
                ),
                const SizedBox(height: 16),
              ],

              const Align(
                alignment: Alignment.centerLeft,
                child: Text('My Posts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 12),

              if (social.userPosts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text('No posts yet', style: TextStyle(color: AppTheme.textHint)),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: social.userPosts.length,
                  itemBuilder: (context, index) {
                    final post = social.userPosts[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/post-detail', arguments: post);
                      },
                      child: post.imageUrl != null
                          ? Image.network(post.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, _, _) => Container(color: AppTheme.dividerColor))
                          : Container(
                              color: AppTheme.primaryColor.withValues(alpha: 0.1),
                              child: const Center(child: Text('📝', style: TextStyle(fontSize: 28))),
                            ),
                    );
                  },
                ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}
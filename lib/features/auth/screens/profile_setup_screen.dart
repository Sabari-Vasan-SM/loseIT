import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lose_it/features/auth/providers/auth_provider.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  /// If true, we're editing an existing profile (not initial setup)
  final bool isEditing;

  const ProfileSetupScreen({super.key, this.isEditing = false});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _bioController = TextEditingController();
  String _selectedAvatar = 'https://i.pravatar.cc/300?img=12';
  bool _isSaving = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final _avatarOptions = [
    'https://i.pravatar.cc/300?img=12',
    'https://i.pravatar.cc/300?img=5',
    'https://i.pravatar.cc/300?img=8',
    'https://i.pravatar.cc/300?img=1',
    'https://i.pravatar.cc/300?img=15',
    'https://i.pravatar.cc/300?img=9',
    'https://i.pravatar.cc/300?img=3',
    'https://i.pravatar.cc/300?img=20',
    'https://i.pravatar.cc/300?img=25',
    'https://i.pravatar.cc/300?img=32',
    'https://i.pravatar.cc/300?img=36',
    'https://i.pravatar.cc/300?img=40',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    // Pre-fill if editing
    final user = ref.read(authProvider).user;
    if (user != null && widget.isEditing) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _contactController.text = user.contactNumber;
      _bioController.text = user.bio;
      _selectedAvatar = user.avatarUrl;
    } else if (user != null) {
      _emailController.text = user.email;
      _nameController.text = user.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _bioController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (widget.isEditing) {
      ref.read(authProvider.notifier).updateProfile(
            name: _nameController.text,
            email: _emailController.text,
            contactNumber: _contactController.text,
            bio: _bioController.text,
            avatarUrl: _selectedAvatar,
          );
    } else {
      ref.read(authProvider.notifier).completeProfile(
            name: _nameController.text,
            email: _emailController.text,
            contactNumber: _contactController.text,
            bio: _bioController.text,
            avatarUrl: _selectedAvatar,
          );
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (widget.isEditing) {
        context.pop();
      }
      // For initial setup, the router redirect will handle navigation
    }
  }

  void _showAvatarPicker() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Choose Avatar',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select a profile picture',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: _avatarOptions.length,
                itemBuilder: (context, index) {
                  final url = _avatarOptions[index];
                  final isSelected = url == _selectedAvatar;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedAvatar = url);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: theme.colorScheme.primary, width: 3)
                            : null,
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(url),
                        backgroundColor:
                            theme.colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: widget.isEditing
          ? AppBar(
              title: const Text('Edit Profile'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => context.pop(),
              ),
            )
          : null,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWide ? 480 : 600),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!widget.isEditing) ...[
                        const SizedBox(height: 20),
                        Text(
                          'Set Up Your Profile',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Let the community know who you are',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 36),
                      ],

                      // Avatar
                      Center(
                        child: GestureDetector(
                          onTap: _showAvatarPicker,
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.secondary,
                                    ],
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 52,
                                  backgroundColor: theme
                                      .colorScheme.surfaceContainerHighest,
                                  backgroundImage:
                                      NetworkImage(_selectedAvatar),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.colorScheme
                                          .surfaceContainerHighest,
                                      width: 3,
                                    ),
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
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton(
                          onPressed: _showAvatarPicker,
                          child: Text(
                            'Change Photo',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Name
                      _FieldLabel(label: 'Full Name', theme: theme),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your full name',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 20),

                      // Email
                      _FieldLabel(label: 'Email', theme: theme),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email is required';
                          if (!v.contains('@')) return 'Invalid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Contact Number
                      _FieldLabel(label: 'Contact Number', theme: theme),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _contactController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter your phone number',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Contact number is required'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Bio
                      _FieldLabel(label: 'Bio (optional)', theme: theme),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _bioController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Tell us about yourself...',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 44),
                            child: Icon(Icons.info_outline_rounded),
                          ),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Save button
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _handleSave,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  widget.isEditing
                                      ? 'Save Changes'
                                      : 'Complete Setup',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final ThemeData theme;

  const _FieldLabel({required this.label, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    );
  }
}

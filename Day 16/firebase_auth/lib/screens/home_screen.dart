import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    await AuthService().logout();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String name = user?.displayName ?? 'Firebase User';
    final String email = user?.email ?? 'No Email';
    final String? photoUrl = user?.photoURL;
    final String initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00E5C8).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -100,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF3D5AFE).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00E5C8), Color(0xFF3D5AFE)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(
                              Icons.bolt_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          _GlassChip(
                            label: 'Signed in',
                            icon: Icons.circle,
                            iconColor: const Color(0xFF00E5C8),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 40),

                            // Avatar
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF00E5C8),
                                        Color(0xFF3D5AFE),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF3D5AFE,
                                        ).withOpacity(0.4),
                                        blurRadius: 30,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: CircleAvatar(
                                    radius: 52,
                                    backgroundColor: const Color(0xFF141828),
                                    backgroundImage: photoUrl != null
                                        ? NetworkImage(photoUrl)
                                        : null,
                                    child: photoUrl == null
                                        ? Text(
                                            initials,
                                            style: const TextStyle(
                                              fontSize: 34,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF00E5C8),
                                    border: Border.all(
                                      color: const Color(0xFF0A0E1A),
                                      width: 2.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              email,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.45),
                              ),
                            ),

                            const SizedBox(height: 36),

                            // Stats row
                            Row(
                              children: [
                                _StatCard(
                                  label: 'Account',
                                  value: 'Active',
                                  icon: Icons.verified_rounded,
                                  iconColor: const Color(0xFF00E5C8),
                                ),
                                const SizedBox(width: 12),
                                _StatCard(
                                  label: 'Auth',
                                  value: photoUrl != null ? 'Google' : 'Email',
                                  icon: Icons.shield_outlined,
                                  iconColor: const Color(0xFF3D5AFE),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Profile info card
                            _InfoCard(
                              children: [
                                _InfoRow(
                                  icon: Icons.person_outline_rounded,
                                  label: 'Display Name',
                                  value: name,
                                ),
                                Divider(
                                  color: Colors.white.withOpacity(0.06),
                                  height: 1,
                                ),
                                _InfoRow(
                                  icon: Icons.mail_outline_rounded,
                                  label: 'Email',
                                  value: email,
                                ),
                                Divider(
                                  color: Colors.white.withOpacity(0.06),
                                  height: 1,
                                ),
                                _InfoRow(
                                  icon: Icons.fingerprint_rounded,
                                  label: 'UID',
                                  value:
                                      (user?.uid ?? '').substring(0, 12) +
                                      '...',
                                  mono: true,
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Settings card
                            _InfoCard(
                              children: [
                                _ActionRow(
                                  icon: Icons.edit_outlined,
                                  label: 'Edit Profile',
                                  onTap: () {},
                                ),
                                Divider(
                                  color: Colors.white.withOpacity(0.06),
                                  height: 1,
                                ),
                                _ActionRow(
                                  icon: Icons.notifications_outlined,
                                  label: 'Notifications',
                                  onTap: () {},
                                ),
                                Divider(
                                  color: Colors.white.withOpacity(0.06),
                                  height: 1,
                                ),
                                _ActionRow(
                                  icon: Icons.security_outlined,
                                  label: 'Privacy & Security',
                                  onTap: () {},
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Logout button
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: OutlinedButton.icon(
                                onPressed: _logout,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.red.withOpacity(0.35),
                                  ),
                                  backgroundColor: Colors.red.withOpacity(0.06),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.logout_rounded,
                                  color: Color(0xFFFF5252),
                                  size: 20,
                                ),
                                label: const Text(
                                  'Sign Out',
                                  style: TextStyle(
                                    color: Color(0xFFFF5252),
                                    fontSize: 15,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _GlassChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;

  const _GlassChip({
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 8),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.04),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: iconColor.withOpacity(0.12),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool mono;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.3), size: 18),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: mono ? 'monospace' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.4), size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.2),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

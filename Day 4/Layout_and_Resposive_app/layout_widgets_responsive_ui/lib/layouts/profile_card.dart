import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int selectedProfileIndex = 0;
  final List<Map<String, String>> profiles = [
    {
      'name': 'Yash Karnik',
      'role': 'Flutter Developer',
      'location': 'Alibag,Raigad,Maharashtra,India',
      'bio': 'Passionate about mobile development and creating beautiful UIs.',
    },
    {
      'name': 'Sarah Smith',
      'role': 'UI/UX Designer',
      'location': 'New York, NY',
      'bio': 'Creating delightful digital experiences one pixel at a time.',
    },
    {
      'name': 'Michael Johnson',
      'role': 'Product Manager',
      'location': 'Austin, TX',
      'bio': 'Building products that users love and businesses need.',
    },
    {
      'name': 'Emily Watson',
      'role': 'Data Scientist',
      'location': 'Seattle, WA',
      'bio': 'Turning data into insights and insights into action.',
    },
    {
      'name': 'David Chen',
      'role': 'Backend Engineer',
      'location': 'Mountain View, CA',
      'bio': 'Building scalable and robust backend systems.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentProfile = profiles[selectedProfileIndex];

    return Stack(
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple[400]!, Colors.deepPurple[700]!],
            ),
          ),
        ),

        // Main content
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Back card
                  Positioned(
                    bottom: 20,
                    child: Transform.translate(
                      offset: const Offset(0, 20),
                      child: Transform.scale(
                        scale: 0.9,
                        child: _buildProfileCard(
                          profiles[(selectedProfileIndex + 1) %
                              profiles.length],
                          isActive: false,
                        ),
                      ),
                    ),
                  ),

                  // Middle card
                  Positioned(
                    bottom: 10,
                    child: Transform.scale(
                      scale: 0.95,
                      child: _buildProfileCard(
                        profiles[(selectedProfileIndex + 2) % profiles.length],
                        isActive: false,
                      ),
                    ),
                  ),

                  // Front card (active)
                  _buildProfileCard(currentProfile, isActive: true),
                ],
              ),
            ),
          ),
        ),

        // Bottom action buttons
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      selectedProfileIndex =
                          (selectedProfileIndex - 1) % profiles.length;
                    });
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.close, color: Colors.white),
                ),
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      selectedProfileIndex =
                          (selectedProfileIndex + 1) % profiles.length;
                    });
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.favorite, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(
    Map<String, String> profile, {
    required bool isActive,
  }) {
    return Container(
      width: 320,
      height: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background image placeholder
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              gradient: LinearGradient(
                colors: [Colors.deepPurple[300]!, Colors.deepPurple[500]!],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.person,
                size: 100,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),

          // Profile info section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and role
                  Text(
                    profile['name']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile['role']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepPurple[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        profile['location']!,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Bio
                  Text(
                    profile['bio']!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Rating
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: Colors.amber[400],
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '4.8 (128 reviews)',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Status badge
          if (isActive)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'Online',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

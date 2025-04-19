import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> slides = [
    {
      "image": "assets/images/anak.jpeg",
      "title": "Berbagi Kebaikan",
      "subtitle": "Setiap donasi membawa harapan baru",
      "color": Colors.blue.shade600,
      "icon": Icons.favorite
    },
    {
      "image": "assets/images/anak2.jpg",
      "title": "Membantu Sesama",
      "subtitle": "Bersama menciptakan perubahan positif",
      "color": Colors.orange.shade600,
      "icon": Icons.people
    },
    {
      "image": "assets/images/anak3.jpg",
      "title": "Peduli Bersama",
      "subtitle": "Satu langkah untuk masa depan lebih baik",
      "color": Colors.green.shade600,
      "icon": Icons.volunteer_activism
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    
    _animationController.forward();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_pageController.hasClients) {
        int nextPage = (_currentIndex + 1) % slides.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
      _startAutoSlide();
    });
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.3),
          child: const Icon(Icons.heart_broken, color: Colors.white),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextButton.icon(
            onPressed: _navigateToLogin,
            icon: const Icon(Icons.login, color: Colors.white, size: 18),
            label: const Text(
              "Masuk",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlideContent(int index) {
    final slide = slides[index];
    
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(slide['image']),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: slide['color'],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        slide['icon'],
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '0${index + 1}/0${slides.length}',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  slide['title'],
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  slide['subtitle'],
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                _buildDonateButton(),
                const SizedBox(height: 48),
                _buildPageIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDonateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _navigateToLogin,
        icon: const Icon(Icons.volunteer_activism, size: 22),
        label: const Text(
          "Donasi Sekarang",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: slides[_currentIndex]['color'],
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: slides[_currentIndex]['color'].withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: slides.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () {
            _pageController.animateToPage(
              entry.key,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          child: Container(
            width: _currentIndex == entry.key ? 24 : 12,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: _currentIndex == entry.key
                  ? slides[_currentIndex]['color']
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: _buildAppBar(),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: PageView.builder(
          controller: _pageController,
          itemCount: slides.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return _buildSlideContent(index);
          },
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/shared_news_card.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/skeleton_loading.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(LoadHomeDataEvent()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading || state.status == HomeStatus.initial) {
              return _buildLoading();
            } else if (state.status == HomeStatus.error) {
              return Center(child: Text('Lỗi: ${state.errorMessage}'));
            }
            
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(context),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildQuickActions(context).animate().fade(duration: 500.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 32),
                      _buildSectionHeader(context, title: 'Dự án Nổi bật', onTapViewAll: () => context.go('/projects'))
                          .animate().fade().slideX(begin: -0.1, end: 0),
                      const SizedBox(height: 16),
                      if (state.featuredProjects.isNotEmpty)
                        _buildCarousel(state, context).animate().fade(delay: 200.ms).scale(begin: const Offset(0.95, 0.95)),
                      const SizedBox(height: 32),
                      _buildSectionHeader(context, title: 'Tin tức hoạt động', onTapViewAll: () => context.go('/news'))
                          .animate().fade().slideX(begin: -0.1, end: 0),
                      const SizedBox(height: 16),
                      _buildNewsList(state, context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE3F2FD), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Xin chào,', style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.normal)),
                const Text('DXMD Vietnam', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1), fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Color(0xFF0D47A1)),
          onPressed: () {},
        ).animate().shake(delay: 1.seconds),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.apartment_rounded, 'label': 'Dự án', 'route': '/projects', 'color': Colors.blue},
      {'icon': Icons.newspaper_rounded, 'label': 'Tin tức', 'route': '/news', 'color': Colors.orange},
      {'icon': Icons.photo_library_rounded, 'label': 'Thư viện', 'route': '/gallery', 'color': Colors.purple},
      {'icon': Icons.handshake_rounded, 'label': 'Tuyển dụng', 'route': '/recruitment', 'color': Colors.green},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((action) {
          return GestureDetector(
            onTap: () => context.go(action['route'] as String),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: (action['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(action['icon'] as IconData, color: action['color'] as Color, size: 30),
                ),
                const SizedBox(height: 8),
                Text(
                  action['label'] as String,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title, required VoidCallback onTapViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 4, height: 20, decoration: BoxDecoration(color: const Color(0xFF0D47A1), borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            ],
          ),
          TextButton(
            onPressed: onTapViewAll,
            child: const Text('Xem tất cả', style: TextStyle(color: Color(0xFF0D47A1))),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(HomeState state, BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 220.0,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
          items: state.featuredProjects.map((project) {
            return GestureDetector(
              onTap: () => context.push('/projects/detail', extra: project),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AppNetworkImage(
                        imageUrl: project.featureImageUrl!,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          project.title,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        AnimatedSmoothIndicator(
          activeIndex: _currentCarouselIndex,
          count: state.featuredProjects.length,
          effect: const ExpandingDotsEffect(
            activeDotColor: Color(0xFF0D47A1),
            dotColor: Colors.black26,
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildNewsList(HomeState state, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: state.latestNews.length,
      itemBuilder: (context, index) {
        final news = state.latestNews[index];
        return SharedNewsCard(
          title: news.title,
          excerpt: news.excerpt,
          imageUrl: news.featureImageUrl,
          onTap: () => context.push('/news/detail', extra: news),
        ).animate().fade(delay: (100 * index).ms).slideY(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildLoading() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SkeletonLoading(width: 200, height: 40, borderRadius: 8),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SkeletonLoading(width: double.infinity, height: 220, borderRadius: 16),
          ),
        ],
      ),
    );
  }
}

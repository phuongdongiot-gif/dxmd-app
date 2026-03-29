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
import '../../../../core/utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _currentCarouselIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentCarouselIndex.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Chào buổi sáng,';
    } else if (hour < 18) {
      return 'Chào buổi chiều,';
    } else if (hour < 22) {
      return 'Chào buổi tối,';
    } else {
      return 'Trăng lên rồi, nghỉ ngơi thôi!';
    }
  }

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
                      _buildSectionHeader(context, title: 'Tiện ích BĐS', onTapViewAll: null)
                          .animate().fade().slideX(begin: -0.1, end: 0),
                      const SizedBox(height: 16),
                      _buildUtilities(context).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),
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
      expandedHeight: 180.0,
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
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
        title: LayoutBuilder(
          builder: (context, constraints) {
            // Hiển thị Search Bar nếu không bị thu nhỏ hoàn toàn
            bool isExpanded = constraints.maxHeight > 100;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_getGreeting(), style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.normal)),
                          const Text('DXMD Vietnam', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1), fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 12),
                  _buildSearchBar(context),
                ],
              ],
            );
          }
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

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/search'),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(Icons.search_rounded, color: Colors.grey[400], size: 18),
            const SizedBox(width: 8),
            Text(
              'Bạn đang tìm kiếm gì?',
              style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.apartment_rounded, 'label': 'Dự án', 'route': '/projects', 'colors': [Colors.blue[400]!, Colors.blue[700]!]},
      {'icon': Icons.newspaper_rounded, 'label': 'Tin bài', 'route': '/news', 'colors': [Colors.orange[400]!, Colors.orange[700]!]},
      {'icon': Icons.photo_library_rounded, 'label': 'Thư viện', 'route': '/gallery', 'colors': [Colors.purple[400]!, Colors.purple[700]!]},
      {'icon': Icons.handshake_rounded, 'label': 'Mời việc', 'route': '/recruitment', 'colors': [Colors.green[400]!, Colors.green[700]!]},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((action) {
          final colors = action['colors'] as List<Color>;
          return GestureDetector(
            onTap: () => context.go(action['route'] as String),
            child: Column(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors[1].withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(action['icon'] as IconData, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 10),
                Text(
                  action['label'] as String,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUtilities(BuildContext context) {
    final utils = [
      {'icon': Icons.calculate_rounded, 'label': 'Lãi suất', 'desc': 'Ước tính vay mua', 'route': '/utilities/loan'},
      {'icon': Icons.explore_rounded, 'label': 'Phong thủy', 'desc': 'Tra cứu mệnh', 'route': '/utilities/feng-shui'},
      {'icon': Icons.receipt_long_rounded, 'label': 'Báo giá', 'desc': 'Gửi tự động', 'route': ''},
    ];

    return SizedBox(
      height: 80,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: utils.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final u = utils[index];
          return GestureDetector(
            onTap: () {
              if ((u['route'] as String).isNotEmpty) {
                context.push(u['route'] as String);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Tính năng Báo Giá đang được cập nhật'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: const Color(0xFF0D47A1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            child: Container(
            width: 150,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(u['icon'] as IconData, color: const Color(0xFF0D47A1), size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        u['label'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)),
                      ),
                      Text(
                        u['desc'] as String,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title, VoidCallback? onTapViewAll}) {
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
          if (onTapViewAll != null)
            TextButton(
              onPressed: onTapViewAll,
              child: const Text('Xem tất cả', style: TextStyle(color: Color(0xFF0D47A1))),
            ),
        ],
      ),
    );
  }

  Widget _buildCarousel(HomeState state, BuildContext context) {
    return RepaintBoundary(
      child: Column(
        children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 220.0,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: context.isTablet || context.isDesktop ? 0.45 : 0.9,
            onPageChanged: (index, reason) {
              _currentCarouselIndex.value = index;
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
        ValueListenableBuilder<int>(
          valueListenable: _currentCarouselIndex,
          builder: (context, value, child) {
            return AnimatedSmoothIndicator(
              activeIndex: value,
              count: state.featuredProjects.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: Color(0xFF0D47A1),
                dotColor: Colors.black26,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
              ),
            );
          },
        ),
      ],
    ),
    );
  }

  Widget _buildNewsList(HomeState state, BuildContext context) {
    if (context.isTablet || context.isDesktop) {
      return RepaintBoundary(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.0, // Thẻ tin tức ngang trên màn hình lớn
          ),
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
        ),
      );
    }

    return RepaintBoundary(
      child: ListView.builder(
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
    ),
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

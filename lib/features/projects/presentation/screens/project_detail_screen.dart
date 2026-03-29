import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/skeleton_loading.dart';
import '../../domain/entities/project.dart';
import '../bloc/project_detail_bloc.dart';
import '../bloc/project_detail_event.dart';
import '../bloc/project_detail_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProjectDetailBloc>()..add(FetchProjectDetailEvent(project.slug)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<ProjectDetailBloc, ProjectDetailState>(
          builder: (context, state) {
            if (state.status == ProjectDetailStatus.loading || state.status == ProjectDetailStatus.initial) {
              return _buildLoading(context);
            } else if (state.status == ProjectDetailStatus.error) {
              return _buildError(context, state.errorMessage ?? "Có lỗi xảy ra khi tải dữ liệu");
            }
            
            final detailedProject = state.project!;
            final acf = detailedProject.acf ?? {};

            return ProjectDetailTabs(project: detailedProject, acf: acf);
          },
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 350.0,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: const SkeletonLoading(width: double.infinity, height: 350, borderRadius: 0),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoading(width: double.infinity, height: 40, borderRadius: 4),
                const SizedBox(height: 20),
                const SkeletonLoading(width: double.infinity, height: 16, borderRadius: 2),
                const SizedBox(height: 8),
                const SkeletonLoading(width: double.infinity, height: 16, borderRadius: 2),
                const SizedBox(height: 8),
                const SkeletonLoading(width: 250, height: 16, borderRadius: 2),
                const SizedBox(height: 40),
                const SkeletonLoading(width: double.infinity, height: 200, borderRadius: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String msg) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lỗi')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(msg),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ProjectDetailBloc>().add(FetchProjectDetailEvent(project.slug));
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailTabs extends StatelessWidget {
  final Project project;
  final Map<String, dynamic> acf;

  const ProjectDetailTabs({super.key, required this.project, required this.acf});

  bool _isValidString(dynamic value) {
    if (value == null) return false;
    if (value is bool) return false;
    final str = value.toString();
    if (str.trim().isEmpty) return false;
    return true;
  }

  String? _forceString(dynamic value) {
    if (!_isValidString(value)) return null;
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <String>[];
    final tabViews = <Widget>[];

    // TỔNG QUAN
    tabs.add('TỔNG QUAN');
    tabViews.add(_buildOverviewContent(context));

    // VỊ TRÍ
    if (_isValidString(acf['vt_desc'])) {
      tabs.add('VỊ TRÍ');
      tabViews.add(_buildSection(context, title: 'Vị Trí', contentHtml: _forceString(acf['vt_desc'])!));
    }

    // MẶT BẰNG
    if (_isValidString(acf['mb_img'])) {
      tabs.add('MẶT BẰNG');
      tabViews.add(
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AppNetworkImage(imageUrl: _forceString(acf['mb_img'])!),
            ).animate().fade().scale(begin: const Offset(0.95, 0.95)),
          ),
        ),
      );
    }

    // TIỆN ÍCH
    if (_isValidString(acf['ti_desc'])) {
      tabs.add('TIỆN ÍCH');
      tabViews.add(_buildSection(context, title: _forceString(acf['ti_title']) ?? 'Tiện Ích', subtitle: _forceString(acf['ti_title_sub']), contentHtml: _forceString(acf['ti_desc'])!));
    }

    // SẢN PHẨM / THIẾT KẾ
    if (_isValidString(acf['sp_desc'])) {
      tabs.add('SẢN PHẨM');
      tabViews.add(_buildSection(context, title: _forceString(acf['sp_title']) ?? 'Sản Phẩm', subtitle: _forceString(acf['sp_title_sub']), contentHtml: _forceString(acf['sp_desc'])!));
    }

    // THƯ VIỆN
    bool hasGallery = acf['tv_imgs'] != null && acf['tv_imgs'] is List && (acf['tv_imgs'] as List).isNotEmpty;
    if (hasGallery) {
      tabs.add('THƯ VIỆN');
      tabViews.add(_buildGallerySection(context, acf['tv_imgs'] as List));
    }

    // LIÊN HỆ
    if (_isValidString(acf['lh_content'])) {
      tabs.add('LIÊN HỆ');
      tabViews.add(
        SingleChildScrollView(
          child: _buildContactSection(context, _forceString(acf['lh_content'])!, _forceString(acf['lh_banner'])),
        ),
      );
    }

    return DefaultTabController(
      length: tabs.length,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildHeroHeader(context),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                  TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[600],
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xFF0D47A1),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0D47A1).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    indicatorWeight: 0,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                    tabs: tabs.map((t) => _buildPillTab(t)).toList(),
                    dividerColor: Colors.transparent,
                  ),
              ),
            ),
          ];
        },
        body: Container(
          color: Colors.white,
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: tabViews,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    String? bannerUrl = _isValidString(acf['intro_banner']) ? _forceString(acf['intro_banner']) : project.featureImageUrl;
    String? logoUrl = _isValidString(acf['intro_logo']) ? _forceString(acf['intro_logo']) : null;

    return SliverAppBar(
      expandedHeight: 350.0,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0D47A1),
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (bannerUrl != null)
              AppNetworkImage(
                imageUrl: bannerUrl,
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent, Colors.black.withOpacity(0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (logoUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: SizedBox(
                        height: 60,
                        child: AppNetworkImage(imageUrl: logoUrl),
                      ),
                    ).animate().fade().scale(),
                  Text(
                    project.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                  ).animate().fade().slideX(begin: -0.2, end: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Tổng Quan'),
            const SizedBox(height: 8),
            _buildHtmlContent(project.content),
            const SizedBox(height: 40),
          ],
        ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, String? subtitle, required String contentHtml}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(title),
            if (subtitle != null && subtitle.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 16, color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ),
            const SizedBox(height: 12),
            _buildHtmlContent(contentHtml),
          ],
        ).animate().fade(duration: 400.ms),
      ),
    );
  }

  Widget _buildHtmlContent(String contentHtml) {
    return Html(
      data: contentHtml,
      style: {
        "body": Style(
          fontSize: FontSize(16.0),
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          lineHeight: LineHeight.em(1.5),
          color: Colors.grey[800],
        ),
        "p": Style(margin: Margins.only(bottom: 15)),
        "img": Style(
          width: Width(100, Unit.percent),
          height: Height.auto(),
          padding: HtmlPaddings.symmetric(vertical: 8.0),
        ),
        "ul": Style(
          padding: HtmlPaddings.only(left: 20),
          margin: Margins.only(bottom: 15),
          listStylePosition: ListStylePosition.outside,
        ),
        "li": Style(margin: Margins.only(bottom: 8)),
      },
      onLinkTap: (url, attributes, element) {
        // Handle links if necessary
      },
    );
  }

  Widget _buildGallerySection(BuildContext context, List<dynamic> imgs) {
    if (imgs.isEmpty) return const SizedBox.shrink();
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: imgs.length,
      itemBuilder: (context, index) {
        final item = imgs[index];
        final url = item is Map ? item['img'] : item.toString();
        final title = item is Map ? item['title'] : '';
        
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (c, u) => Container(color: Colors.grey[200]),
              ),
              if (title != null && title.toString().isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Text(
                      title.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ).animate().fade(delay: (50 * index).ms).scale(begin: const Offset(0.9, 0.9));
      },
    );
  }

  Widget _buildContactSection(BuildContext context, String contactHtml, String? bannerUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (bannerUrl != null && bannerUrl.trim().isNotEmpty)
            SizedBox(
              height: 150,
              width: double.infinity,
              child: AppNetworkImage(imageUrl: bannerUrl),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: _buildHtmlContent(contactHtml),
          ),
        ],
      ),
    ).animate().fade().slideY(begin: 0.1, end: 0);
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPillTab(String text) {
    return Tab(
      height: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        alignment: Alignment.center,
        child: Text(text),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

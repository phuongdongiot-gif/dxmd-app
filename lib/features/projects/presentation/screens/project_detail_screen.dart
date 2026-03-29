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

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeroHeader(context, detailedProject, acf),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOverviewContent(detailedProject),
                      if (_isValidString(acf['ti_desc']))
                        _buildSection(
                          title: _forceString(acf['ti_title']) ?? 'Tiện Ích',
                          subtitle: _forceString(acf['ti_title_sub']),
                          contentHtml: _forceString(acf['ti_desc'])!,
                        ),
                      if (_isValidString(acf['sp_desc']))
                        _buildSection(
                          title: _forceString(acf['sp_title']) ?? 'Thiết Kế',
                          subtitle: _forceString(acf['sp_title_sub']),
                          contentHtml: _forceString(acf['sp_desc'])!,
                        ),
                      if (_isValidString(acf['mb_img']))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AppNetworkImage(
                              imageUrl: _forceString(acf['mb_img'])!,
                            ),
                          ),
                        ),
                      if (_isValidString(acf['vt_desc']))
                        _buildSection(
                          title: 'Vị Trí',
                          contentHtml: _forceString(acf['vt_desc'])!,
                        ),
                      if (_isValidString(acf['lh_content']))
                        _buildContactSection(_forceString(acf['lh_content'])!, _forceString(acf['lh_banner'])),
                      const SizedBox(height: 60),
                    ],
                  ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _isValidString(dynamic value) {
    if (value == null) return false;
    if (value is bool) return false; // WP ACF returns false for empty images/fields
    final str = value.toString();
    if (str.trim().isEmpty) return false;
    return true;
  }

  String? _forceString(dynamic value) {
    if (!_isValidString(value)) return null;
    return value.toString();
  }

  Widget _buildHeroHeader(BuildContext context, Project detailedProject, Map<String, dynamic> acf) {
    String? bannerUrl = _isValidString(acf['intro_banner']) ? _forceString(acf['intro_banner']) : detailedProject.featureImageUrl;
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
                    ),
                  Text(
                    detailedProject.title,
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

  Widget _buildOverviewContent(Project detailedProject) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Tổng Quan'),
          const SizedBox(height: 8),
          Html(
            data: detailedProject.content,
            style: {
              "body": Style(
                fontSize: FontSize(16.0),
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                lineHeight: LineHeight.em(1.5),
                color: Colors.grey[800],
              ),
              "img": Style(
                width: Width(double.infinity),
                padding: HtmlPaddings.symmetric(vertical: 8.0),
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, String? subtitle, required String contentHtml}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
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
          Html(
            data: contentHtml,
            style: {
              "body": Style(
                fontSize: FontSize(16.0),
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                lineHeight: LineHeight.em(1.5),
                color: Colors.grey[800],
              ),
              "p": Style(margin: Margins.only(bottom: 10)),
              "img": Style(
                width: Width(double.infinity),
                padding: HtmlPaddings.symmetric(vertical: 8.0),
              ),
              "ul": Style(
                  padding: HtmlPaddings.only(left: 20),
                  margin: Margins.zero,
                  listStylePosition: ListStylePosition.outside
              ),
              "li": Style(
                  margin: Margins.only(bottom: 5)
              )
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(String contactHtml, String? bannerUrl) {
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
            child: Html(
              data: contactHtml,
              style: {
                "body": Style(
                  fontSize: FontSize(15.0),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                "h3": Style(
                  color: const Color(0xFF0D47A1),
                  margin: Margins.only(bottom: 12),
                ),
                "ul": Style(
                  padding: HtmlPaddings.only(left: 15),
                ),
                "li": Style(
                  margin: Margins.only(bottom: 8),
                  color: Colors.black87,
                ),
                "a": Style(
                  color: const Color(0xFF0D47A1),
                  textDecoration: TextDecoration.none,
                  fontWeight: FontWeight.w600,
                ),
              },
            ),
          ),
        ],
      ),
    );
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
                const SkeletonLoading(width: 200, height: 30, borderRadius: 4),
                const SizedBox(height: 20),
                const SkeletonLoading(width: double.infinity, height: 16, borderRadius: 2),
                const SizedBox(height: 8),
                const SkeletonLoading(width: double.infinity, height: 16, borderRadius: 2),
                const SizedBox(height: 8),
                const SkeletonLoading(width: 250, height: 16, borderRadius: 2),
                const SizedBox(height: 40),
                const SkeletonLoading(width: 150, height: 30, borderRadius: 4),
                const SizedBox(height: 20),
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

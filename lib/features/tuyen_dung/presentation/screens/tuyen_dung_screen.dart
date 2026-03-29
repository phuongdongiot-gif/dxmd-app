import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/skeleton_loading.dart';
import '../../domain/entities/recruitment.dart';
import '../bloc/recruitment_bloc.dart';
import '../bloc/recruitment_event.dart';
import '../bloc/recruitment_state.dart';

class RecruitmentScreen extends StatefulWidget {
  const RecruitmentScreen({super.key});

  @override
  State<RecruitmentScreen> createState() => _RecruitmentScreenState();
}

class _RecruitmentScreenState extends State<RecruitmentScreen> {
  late final RecruitmentBloc _recruitmentBloc;

  @override
  void initState() {
    super.initState();
    _recruitmentBloc = sl<RecruitmentBloc>()..add(FetchRecruitmentsEvent());
  }

  @override
  void dispose() {
    _recruitmentBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _recruitmentBloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: BlocBuilder<RecruitmentBloc, RecruitmentState>(
          builder: (context, state) {
            if (state.status == RecruitmentStatus.initial || state.status == RecruitmentStatus.loading) {
              return _buildLoading();
            }

            if (state.status == RecruitmentStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Lỗi: ${state.errorMessage}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _recruitmentBloc.add(FetchRecruitmentsEvent()),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            final recruitments = state.recruitments;
            if (recruitments.isEmpty) {
              return const Center(child: Text('Hiện tại chưa có tin tuyển dụng nào.'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                _recruitmentBloc.add(FetchRecruitmentsEvent());
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200.0,
                    pinned: true,
                    stretch: true,
                    elevation: 0,
                    backgroundColor: const Color(0xFF0D47A1),
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [StretchMode.zoomBackground],
                      title: const Text(
                        'Cơ Hội Nghề Nghiệp',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 2))],
                        ),
                      ),
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -50,
                              top: -50,
                              child: Icon(Icons.work_outline, size: 200, color: Colors.white.withOpacity(0.1)),
                            ),
                            Positioned(
                              left: -20,
                              bottom: -20,
                              child: Icon(Icons.business_center, size: 120, color: Colors.white.withOpacity(0.05)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final job = recruitments[index];
                          return _buildJobCard(context, job);
                        },
                        childCount: recruitments.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Recruitment job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        childrenPadding: const EdgeInsets.all(20.0),
        iconColor: const Color(0xFF0D47A1),
        collapsedIconColor: Colors.grey,
        title: Text(
          job.position ?? job.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D47A1),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isValid(job.qty))
                _buildInfoRow(Icons.people_outline, 'Số lượng: ${job.qty}'),
              const SizedBox(height: 4),
              if (_isValid(job.dateEnd))
                _buildInfoRow(Icons.event_outlined, 'Hạn nộp: ${job.dateEnd}'),
              const SizedBox(height: 4),
              if (_isValid(job.address))
                _buildInfoRow(Icons.location_on_outlined, job.address!),
            ],
          ),
        ),
        children: [
          const Divider(),
          const SizedBox(height: 10),
          if (_isValid(job.content))
            Html(
              data: job.content,
              style: {
                "body": Style(
                  fontSize: FontSize(15.0),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  color: Colors.black87,
                  lineHeight: LineHeight.em(1.5),
                ),
                "h3": Style(
                  color: const Color(0xFF0D47A1),
                  fontSize: FontSize(16.0),
                  margin: Margins.only(top: 10, bottom: 5),
                ),
                "ul": Style(
                  padding: HtmlPaddings.only(left: 15),
                  margin: Margins.only(bottom: 10),
                ),
                "li": Style(
                  margin: Margins.only(bottom: 5),
                ),
              },
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  bool _isValid(String? value) {
    if (value == null) return false;
    if (value.trim().isEmpty) return false;
    return true;
  }

  Widget _buildLoading() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200.0,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: const SkeletonLoading(width: double.infinity, height: 200, borderRadius: 0),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SkeletonLoading(width: 200, height: 24, borderRadius: 4),
                        const SizedBox(height: 12),
                        const SkeletonLoading(width: 150, height: 16, borderRadius: 4),
                        const SizedBox(height: 8),
                        const SkeletonLoading(width: 120, height: 16, borderRadius: 4),
                      ],
                    ),
                  ),
                );
              },
              childCount: 4,
            ),
          ),
        ),
      ],
    );
  }
}

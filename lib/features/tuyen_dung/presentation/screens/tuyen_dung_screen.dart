import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/skeleton_loading.dart';
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

            final recruitment = state.recruitment;
            if (recruitment == null) {
              return const Center(child: Text('Không tìm thấy dữ liệu tuyển dụng.'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                _recruitmentBloc.add(FetchRecruitmentsEvent());
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250.0,
                    pinned: true,
                    stretch: true,
                    elevation: 0,
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [StretchMode.zoomBackground],
                      title: Text(
                        recruitment.title.length > 25 ? 'Cơ hội nghề nghiệp' : recruitment.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 2))]),
                      ),
                      background: recruitment.featureImageUrl != null
                          ? AppNetworkImage(
                              imageUrl: recruitment.featureImageUrl!,
                            )
                          : Container(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recruitment.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 26, color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(height: 16),
                          Html(
                            data: recruitment.content,
                            style: {
                              "body": Style(
                                fontSize: FontSize(16.0),
                                lineHeight: LineHeight.number(1.6),
                                margin: Margins.zero,
                              ),
                              "h1": Style(
                                fontSize: FontSize(22.0),
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                              "h2": Style(
                                fontSize: FontSize(20.0),
                                fontWeight: FontWeight.bold,
                              ),
                              "li": Style(
                                margin: Margins.only(bottom: 8.0),
                              ),
                            },
                          ),
                          const SizedBox(height: 40),
                        ],
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

  Widget _buildLoading() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250.0,
          pinned: true,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('Cơ hội nghề nghiệp', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonLoading(width: 200, height: 30),
                SizedBox(height: 16),
                SkeletonLoading(width: double.infinity, height: 20),
                SizedBox(height: 8),
                SkeletonLoading(width: double.infinity, height: 20),
                SizedBox(height: 8),
                SkeletonLoading(width: double.infinity, height: 20),
                SizedBox(height: 8),
                SkeletonLoading(width: 250, height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

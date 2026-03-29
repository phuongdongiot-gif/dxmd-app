import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/skeleton_loading.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_state.dart';
import '../../../../core/widgets/modern_header_background.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final ScrollController _scrollController = ScrollController();
  late final ProjectsBloc _projectsBloc;

  @override
  void initState() {
    super.initState();
    _projectsBloc = sl<ProjectsBloc>()..add(FetchProjectsEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      if (mounted) {
        _projectsBloc.add(LoadMoreProjectsEvent());
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _projectsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _projectsBloc,
      child: Scaffold(
        body: BlocBuilder<ProjectsBloc, ProjectsState>(
          builder: (context, state) {
            if (state.status == ProjectsStatus.initial || (state.status == ProjectsStatus.loading && state.projects.isEmpty)) {
              return _buildLoading();
            }

            return RefreshIndicator(
              onRefresh: () async {
                _projectsBloc.add(FetchProjectsEvent());
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar.large(
                    expandedHeight: 160.0,
                    pinned: true,
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.15),
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      title: const Text(
                        'Dự án nổi bật', 
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          fontSize: 28,
                          shadows: [
                            Shadow(
                              color: Colors.black12,
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      titlePadding: const EdgeInsets.only(left: 20, bottom: 20),
                      background: const ModernHeaderBackground(),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index >= state.projects.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final project = state.projects[index];
                          return GestureDetector(
                            onTap: () {
                              context.push('/projects/detail', extra: project);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 28),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (project.featureImageUrl != null)
                                    Stack(
                                      children: [
                                        AppNetworkImage(
                                          imageUrl: project.featureImageUrl!,
                                          height: 240,
                                          width: double.infinity,
                                        ),
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.4),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 16,
                                          left: 16,
                                          right: 16,
                                          child: Text(
                                            project.title,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              letterSpacing: 0.2,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Container(
                                      height: 240, 
                                      width: double.infinity, 
                                      color: Colors.grey[200], 
                                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                                    ),
                                ],
                              ),
                            ),
                          ).animate().fade(duration: 500.ms).slideY(begin: 0.1, end: 0, delay: (50 * (index % 10)).ms);
                        },
                        childCount: state.hasReachedMax ? state.projects.length : state.projects.length + 1,
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
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 140.0,
            pinned: true,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Dự án Nổi bật', style: TextStyle(fontWeight: FontWeight.bold)),
              titlePadding: EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SkeletonLoading(width: double.infinity, height: 220, borderRadius: 20),
                        const SizedBox(height: 16),
                        const SkeletonLoading(width: 250, height: 24, borderRadius: 4),
                      ],
                    ),
                  );
                },
                childCount: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

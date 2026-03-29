import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/skeleton_loading.dart';
import '../bloc/projects_bloc.dart';
import '../bloc/projects_event.dart';
import '../bloc/projects_state.dart';

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
                    expandedHeight: 140.0,
                    pinned: true,
                    surfaceTintColor: Colors.transparent,
                    flexibleSpace: const FlexibleSpaceBar(
                      title: Text('Dự án Nổi bật', style: TextStyle(fontWeight: FontWeight.bold)),
                      titlePadding: EdgeInsets.only(left: 16, bottom: 16),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardTheme.color,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (project.featureImageUrl != null)
                                    AppNetworkImage(
                                      imageUrl: project.featureImageUrl!,
                                      height: 220,
                                      width: double.infinity,
                                    )
                                  else
                                    Container(height: 220, width: double.infinity, color: Colors.grey[200], child: const Icon(Icons.image)),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      project.title,
                                      style: Theme.of(context).textTheme.titleLarge,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
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

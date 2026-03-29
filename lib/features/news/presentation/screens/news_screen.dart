import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/shared_news_card.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/skeleton_loading.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final ScrollController _scrollController = ScrollController();
  late final NewsBloc _newsBloc;

  @override
  void initState() {
    super.initState();
    _newsBloc = sl<NewsBloc>()..add(FetchNewsEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      if (mounted) {
        _newsBloc.add(LoadMoreNewsEvent());
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
    _newsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _newsBloc,
      child: Scaffold(
        body: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state.status == NewsStatus.initial || (state.status == NewsStatus.loading && state.newsList.isEmpty)) {
              return _buildLoading();
            }

            return RefreshIndicator(
              onRefresh: () async {
                _newsBloc.add(FetchNewsEvent());
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
                      title: Text('Tin Tức', style: TextStyle(fontWeight: FontWeight.bold)),
                      titlePadding: EdgeInsets.only(left: 16, bottom: 16),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index >= state.newsList.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final newsItem = state.newsList[index];
                          return SharedNewsCard(
                            title: newsItem.title,
                            excerpt: newsItem.excerpt,
                            imageUrl: newsItem.featureImageUrl,
                            onTap: () {
                              context.push('/news/detail', extra: newsItem);
                            },
                          );
                        },
                        childCount: state.hasReachedMax ? state.newsList.length : state.newsList.length + 1,
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
              title: Text('Tin Tức', style: TextStyle(fontWeight: FontWeight.bold)),
              titlePadding: EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SkeletonLoading(width: 110, height: 110, borderRadius: 16),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SkeletonLoading(width: double.infinity, height: 20),
                              SizedBox(height: 8),
                              SkeletonLoading(width: 150, height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

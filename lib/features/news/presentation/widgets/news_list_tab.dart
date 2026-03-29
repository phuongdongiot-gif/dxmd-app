import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/skeleton_loading.dart';
import '../../../../core/widgets/shared_news_card.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';

class NewsListTab extends StatefulWidget {
  final int? categoryId;

  const NewsListTab({super.key, this.categoryId});

  @override
  State<NewsListTab> createState() => _NewsListTabState();
}

class _NewsListTabState extends State<NewsListTab> with AutomaticKeepAliveClientMixin {
  late final NewsBloc _newsBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true; // Keep state when switching tabs!

  @override
  void initState() {
    super.initState();
    _newsBloc = sl<NewsBloc>(param1: widget.categoryId)..add(FetchNewsEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // Need to avoid using dispose before scroll controller since it can trigger scroll events
    _scrollController.dispose();
    _newsBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _newsBloc.add(LoadMoreNewsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: _newsBloc,
      child: RefreshIndicator(
        onRefresh: () async {
          _newsBloc.add(FetchNewsEvent());
        },
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state.status == NewsStatus.initial || (state.status == NewsStatus.loading && state.newsList.isEmpty)) {
              return _buildLoading();
            }

            if (state.status == NewsStatus.error && state.newsList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Lỗi tải dữ liệu. ${state.errorMessage}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _newsBloc.add(FetchNewsEvent()),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            if (state.newsList.isEmpty) {
              return const Center(
                child: Text('Chưa có tin bài nào ở chuyên mục này.'),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              itemCount: state.newsList.length + (state.hasReachedMax ? 0 : 1),
              itemBuilder: (context, index) {
                if (index >= state.newsList.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }

                final news = state.newsList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: SharedNewsCard(
                    title: news.title ?? '',
                    excerpt: news.excerpt ?? '',
                    imageUrl: news.featureImageUrl,
                    onTap: () {
                      context.push('/news/${news.id}', extra: news);
                    },
                  ),
                ).animate().fade(duration: 400.ms).slideY(begin: 0.2, end: 0, delay: (50 * (index % 10)).ms);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonLoading(width: double.infinity, height: 200, borderRadius: 12),
              const SizedBox(height: 12),
              const SkeletonLoading(width: 100, height: 16, borderRadius: 12), // Category
              const SizedBox(height: 8),
              const SkeletonLoading(width: double.infinity, height: 20, borderRadius: 4), // Title
              const SizedBox(height: 4),
              const SkeletonLoading(width: 200, height: 20, borderRadius: 4), // Title line 2
            ],
          ),
        );
      },
    );
  }
}

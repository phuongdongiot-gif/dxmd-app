import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/skeleton_loading.dart';
import '../bloc/thu_vien_bloc.dart';
import '../bloc/thu_vien_event.dart';
import '../bloc/thu_vien_state.dart';

class ThuVienScreen extends StatefulWidget {
  const ThuVienScreen({super.key});

  @override
  State<ThuVienScreen> createState() => _ThuVienScreenState();
}

class _ThuVienScreenState extends State<ThuVienScreen> {
  final ScrollController _scrollController = ScrollController();
  late final ThuVienBloc _thuVienBloc;

  @override
  void initState() {
    super.initState();
    _thuVienBloc = sl<ThuVienBloc>()..add(FetchThuVienEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      if (mounted) {
        _thuVienBloc.add(LoadMoreThuVienEvent());
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
    _thuVienBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _thuVienBloc,
      child: Scaffold(
        body: BlocBuilder<ThuVienBloc, ThuVienState>(
          builder: (context, state) {
            if (state.status == ThuVienStatus.initial || (state.status == ThuVienStatus.loading && state.thuVienList.isEmpty)) {
              return _buildLoading();
            }

            return RefreshIndicator(
              onRefresh: () async {
                _thuVienBloc.add(FetchThuVienEvent());
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
                      title: Text('Thư Viện Ảnh', style: TextStyle(fontWeight: FontWeight.bold)),
                      titlePadding: EdgeInsets.only(left: 16, bottom: 16),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index >= state.thuVienList.length) {
                            return const SkeletonLoading(width: double.infinity, height: double.infinity, borderRadius: 16);
                          }

                          final item = state.thuVienList[index];
                          return GestureDetector(
                            onTap: () {
                              if (item.featureImageUrl != null) {
                                context.push('/gallery/detail', extra: item);
                              }
                            },
                            child: Hero(
                              tag: 'gallery_image_${item.id}',
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardTheme.color,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    if (item.featureImageUrl != null)
                                      Positioned.fill(
                                        child: AppNetworkImage(
                                          imageUrl: item.featureImageUrl!,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                                          gradient: LinearGradient(
                                            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        alignment: Alignment.bottomLeft,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            item.title,
                                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: state.hasReachedMax ? state.thuVienList.length : state.thuVienList.length + 2,
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
              title: Text('Thư Viện Ảnh', style: TextStyle(fontWeight: FontWeight.bold)),
              titlePadding: EdgeInsets.only(left: 16, bottom: 16),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return const SkeletonLoading(width: double.infinity, height: double.infinity, borderRadius: 16);
                },
                childCount: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

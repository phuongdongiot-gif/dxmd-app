import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/skeleton_loading.dart';
import '../bloc/thu_vien_bloc.dart';
import '../bloc/thu_vien_event.dart';
import '../bloc/thu_vien_state.dart';
import '../../domain/entities/thu_vien.dart';
import '../../../../core/utils/responsive.dart';

class ThuVienListTab extends StatefulWidget {
  final int? categoryId;

  const ThuVienListTab({super.key, required this.categoryId});

  @override
  State<ThuVienListTab> createState() => _ThuVienListTabState();
}

class _ThuVienListTabState extends State<ThuVienListTab> {
  final ScrollController _scrollController = ScrollController();
  late final ThuVienBloc _thuVienBloc;

  @override
  void initState() {
    super.initState();
    _thuVienBloc = sl<ThuVienBloc>()..add(FetchThuVienEvent(categoryId: widget.categoryId));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      if (mounted) {
        _thuVienBloc.add(LoadMoreThuVienEvent(categoryId: widget.categoryId));
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

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Could not launch $url");
    }
  }

  void _handleItemClick(BuildContext context, ThuVien item) {
    // 7: Image, 8: Video, 9: Document
    if (item.categoryId == 8) {
      // VIdeo
      if (item.videoId != null && item.videoId!.isNotEmpty) {
        _launchUrl("https://www.youtube.com/watch?v=${item.videoId}");
      }
    } else if (item.categoryId == 9) {
      // Document
      if (item.taiLieuList.isNotEmpty) {
        _showDocumentBottomSheet(context, item);
      }
    } else {
      // Default to Image Carousel
      if (item.featureImageUrl != null || item.listImg.isNotEmpty) {
        context.push('/gallery/detail', extra: item);
      }
    }
  }

  void _showDocumentBottomSheet(BuildContext context, ThuVien item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D47A1).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.folder_shared_rounded, color: Color(0xFF0D47A1), size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: item.taiLieuList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final doc = item.taiLieuList[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.withOpacity(0.1)),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent),
                            ),
                            title: Text(
                              doc['file_name'] ?? 'Tài liệu ${index + 1}', 
                              style: const TextStyle(
                                fontSize: 15, 
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF334155),
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0D47A1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            onTap: () {
                              Navigator.pop(context);
                              if (doc['file_url'] != null && doc['file_url']!.isNotEmpty) {
                                _launchUrl(doc['file_url']!);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _thuVienBloc,
      child: BlocBuilder<ThuVienBloc, ThuVienState>(
        builder: (context, state) {
          if (state.status == ThuVienStatus.initial || (state.status == ThuVienStatus.loading && state.thuVienList.isEmpty)) {
            return _buildLoading();
          }

          if (state.status == ThuVienStatus.success && state.thuVienList.isEmpty) {
            return const Center(child: Text("Chưa có nội dung ở danh mục này."));
          }

          return RefreshIndicator(
            onRefresh: () async {
              _thuVienBloc.add(FetchThuVienEvent(categoryId: widget.categoryId));
            },
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.isDesktop ? 6 : context.isTablet ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: state.hasReachedMax ? state.thuVienList.length : state.thuVienList.length + 2,
              itemBuilder: (context, index) {
                if (index >= state.thuVienList.length) {
                  return const SkeletonLoading(width: double.infinity, height: double.infinity, borderRadius: 16);
                }

                final item = state.thuVienList[index];
                
                // Get Icon based on category
                IconData typeIcon;
                if (item.categoryId == 8) typeIcon = Icons.play_circle_fill_rounded;
                else if (item.categoryId == 9) typeIcon = Icons.picture_as_pdf_rounded;
                else typeIcon = Icons.photo_library_rounded;

                return GestureDetector(
                  onTap: () => _handleItemClick(context, item),
                  child: Hero(
                    tag: 'gallery_image_${item.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          if (item.featureImageUrl != null)
                            Positioned.fill(
                              child: AppNetworkImage(
                                imageUrl: item.featureImageUrl!,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            
                          // Category indicator icon top right with Glassmorphism
                          Positioned(
                            top: 12,
                            right: 12,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
                                  ),
                                  child: Icon(typeIcon, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ),
                          
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                gradient: LinearGradient(
                                  colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              alignment: Alignment.bottomLeft,
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  item.title,
                                  style: const TextStyle(
                                    color: Colors.white, 
                                    fontSize: 14, 
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                  ),
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
                ).animate(delay: (index % 6 * 50).ms).fade(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return const SkeletonLoading(width: double.infinity, height: double.infinity, borderRadius: 20);
      },
    );
  }
}

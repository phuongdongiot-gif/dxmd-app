import 'package:flutter/material.dart';
import '../widgets/thu_vien_list_tab.dart';
import '../../../../core/widgets/modern_header_background.dart';

class ThuVienScreen extends StatelessWidget {
  const ThuVienScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.15),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          toolbarHeight: 80,
          flexibleSpace: const FlexibleSpaceBar(
            background: ModernHeaderBackground(),
          ),
          centerTitle: false,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'KHÁM PHÁ BỘ SƯU TẬP',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFF0D47A1),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Thư Viện',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                  shadows: [
                    Shadow(color: Colors.black12, offset: Offset(0, 1), blurRadius: 2),
                  ],
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.label,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                  indicator: BoxDecoration(
                    color: const Color(0xFF0D47A1),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D47A1).withOpacity(0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF64748B),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  tabs: [
                    _buildPillTab("Tất cả"),
                    _buildPillTab("Hình ảnh sự kiện"),
                    _buildPillTab("Phim tư liệu"),
                    _buildPillTab("Tài liệu"),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            ThuVienListTab(categoryId: null), // Tất cả
            ThuVienListTab(categoryId: 7),    // Hình ảnh sự kiện
            ThuVienListTab(categoryId: 8),    // Phim tư liệu
            ThuVienListTab(categoryId: 9),    // Tài liệu
          ],
        ),
      ),
    );
  }

  Widget _buildPillTab(String text) {
    return Tab(
      height: 44,
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

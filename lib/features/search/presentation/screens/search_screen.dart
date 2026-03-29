import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = ['The Privia', 'Gem Sky World', 'Opal Boulevard', 'Tin tức 2024'];
  bool _isSearching = false;

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      _isSearching = true;
      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
      }
    });

    // Mock API delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B)),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Nhập tên dự án, tin tức...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _isSearching = false;
                      });
                    },
                  )
                : null,
          ),
          style: const TextStyle(fontSize: 16, color: Color(0xFF1E293B)),
          textInputAction: TextInputAction.search,
          onSubmitted: _performSearch,
          onChanged: (val) {
            setState(() {});
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[200], height: 1.0),
        ),
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D47A1)))
          : _searchController.text.isEmpty
              ? _buildRecentSearches()
              : _buildSearchResults(),
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TÌM KIẾM GẦN ĐÂY',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
              if (_recentSearches.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _recentSearches.clear();
                    });
                  },
                  child: const Text('Xóa', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _recentSearches.map((term) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = term;
                  _performSearch(term);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.history_rounded, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(term, style: const TextStyle(color: Color(0xFF334155))),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.grey, fontSize: 15),
              children: [
                const TextSpan(text: 'Kết quả tìm kiếm cho: '),
                TextSpan(
                  text: '"${_searchController.text}"',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'Không tìm thấy kết quả nào phù hợp.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Vui lòng thử lại với từ khóa khác.',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

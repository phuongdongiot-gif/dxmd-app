import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FengShuiScreen extends StatefulWidget {
  const FengShuiScreen({super.key});

  @override
  State<FengShuiScreen> createState() => _FengShuiScreenState();
}

class _FengShuiScreenState extends State<FengShuiScreen> {
  int _selectedYear = 1990;
  String _selectedGender = 'Nam';
  
  String _element = '-';
  String _goodDirs = '-';
  String _badDirs = '-';

  @override
  void initState() {
    super.initState();
    _calculateFengShui();
  }

  void _calculateFengShui() {
    // Simple Mock Feng Shui logic for demo purposes
    // Mệnh
    final lastDigit = _selectedYear % 10;
    if (lastDigit == 4 || lastDigit == 5) _element = 'Kim';
    else if (lastDigit == 0 || lastDigit == 1) _element = 'Kim'; // fake logic for demo
    else if (lastDigit == 2 || lastDigit == 3) _element = 'Thủy';
    else if (lastDigit == 6 || lastDigit == 7) _element = 'Hỏa';
    else _element = 'Thổ';

    // Bát trạch theo giới tính (fake logic)
    if (_selectedGender == 'Nam') {
      _goodDirs = 'Đông, Nam, Bắc, Đông Nam';
      _badDirs = 'Tây, Tây Bắc, Tây Nam, Đông Bắc';
    } else {
      _goodDirs = 'Tây, Tây Bắc, Tây Nam, Đông Bắc';
      _badDirs = 'Đông, Nam, Bắc, Đông Nam';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Tra Cứu Phong Thủy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thông tin gia chủ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Năm sinh', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F7FA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: _selectedYear,
                                  isExpanded: true,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B)),
                                  items: List.generate(70, (index) => 1950 + index).map((e) {
                                    return DropdownMenuItem<int>(value: e, child: Text(e.toString()));
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedYear = val);
                                      _calculateFengShui();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Giới tính', style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F7FA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedGender,
                                  isExpanded: true,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B)),
                                  items: ['Nam', 'Nữ'].map((e) {
                                    return DropdownMenuItem<String>(value: e, child: Text(e));
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedGender = val);
                                      _calculateFengShui();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF1976D2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF0D47A1).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bản Mệnh:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Text(_element, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: Colors.white.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  const Text('Hướng nhà Đại Cát (Tốt):', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(_goodDirs, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Text('Hướng nhà Đại Hung (Xấu):', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(_badDirs, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

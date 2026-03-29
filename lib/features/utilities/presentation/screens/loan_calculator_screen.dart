import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LoanCalculatorScreen extends StatefulWidget {
  const LoanCalculatorScreen({super.key});

  @override
  State<LoanCalculatorScreen> createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _termController = TextEditingController();

  double _loanPercentage = 70.0; // 70% mặc định
  double _monthlyPayment = 0.0;
  double _totalInterest = 0.0;
  
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void initState() {
    super.initState();
    _interestController.text = "7.5";
    _termController.text = "20";
  }

  void _calculateLoan() {
    final priceStr = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (priceStr.isEmpty) return;

    final double homePrice = double.tryParse(priceStr) ?? 0;
    final double loanAmount = homePrice * (_loanPercentage / 100);
    final double annualInterestRate = double.tryParse(_interestController.text) ?? 7.5;
    final int termYears = int.tryParse(_termController.text) ?? 20;

    final double monthlyInterestRate = (annualInterestRate / 100) / 12;
    final int numberOfPayments = termYears * 12;

    // Tính nợ gốc hàng tháng (Trả góp đều)
    final double principalRepayment = loanAmount / numberOfPayments;
    
    // Tính lãi tháng đầu (Dư nợ giảm dần)
    final double firstMonthInterest = loanAmount * monthlyInterestRate;
    
    // Tính tổng lãi tạm tính theo dư nợ giảm dần
    double totalInterest = 0;
    double remainingPrincipal = loanAmount;
    for (int i = 0; i < numberOfPayments; i++) {
      totalInterest += remainingPrincipal * monthlyInterestRate;
      remainingPrincipal -= principalRepayment;
    }

    setState(() {
      _monthlyPayment = principalRepayment + firstMonthInterest;
      _totalInterest = totalInterest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Tính Vay Mua Nhà', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputCard(),
            const SizedBox(height: 24),
            _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Giá trị Bất Động Sản (VNĐ)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
            decoration: InputDecoration(
              hintText: 'VD: 3,000,000,000',
              hintStyle: TextStyle(color: Colors.grey[300], fontSize: 18),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onChanged: (_) => _calculateLoan(),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tỷ lệ vay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
              Text('${_loanPercentage.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D47A1))),
            ],
          ),
          Slider(
            value: _loanPercentage,
            min: 10,
            max: 100,
            divisions: 90,
            activeColor: const Color(0xFF0D47A1),
            inactiveColor: Colors.grey[200],
            onChanged: (val) {
              setState(() => _loanPercentage = val);
              _calculateLoan();
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thời hạn vay (Năm)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _termController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                      ),
                      onChanged: (_) => _calculateLoan(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Lãi suất (% / Năm)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _interestController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                      ),
                      onChanged: (_) => _calculateLoan(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Số tiền trả tháng đầu tiên', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            _monthlyPayment > 0 ? _currencyFormat.format(_monthlyPayment) : '0 đ',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng lãi phải trả:', style: TextStyle(color: Colors.white70)),
              Text(
                _totalInterest > 0 ? _currencyFormat.format(_totalInterest) : '0 đ',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

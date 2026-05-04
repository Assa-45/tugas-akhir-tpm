import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _amountCtrl = TextEditingController(text: '850000');
  String _baseCurrency = 'IDR';
  bool _isLoading = false; // State untuk loading

  // Rate awal (Mock/Fallback jika API gagal)
  final Map<String, double> _rates = {
    'IDR': 1.0, 'USD': 0.000062, 'EUR': 0.000057,
    'GBP': 0.000049, 'KRW': 0.082, 'SGD': 0.000084,
    'AUD': 0.000095, 'JPY': 0.0094,
  };

  final Map<String, String> _currencyFlags = {
    'IDR': '🇮🇩', 'USD': '🇺🇸', 'EUR': '🇪🇺',
    'GBP': '🇬🇧', 'KRW': '🇰🇷', 'SGD': '🇸🇬',
    'AUD': '🇦🇺', 'JPY': '🇯🇵',
  };

  final Map<String, String> _currencySymbols = {
    'IDR': 'Rp', 'USD': '\$', 'EUR': '€',
    'GBP': '£', 'KRW': '₩', 'SGD': 'S\$',
    'AUD': 'A\$', 'JPY': '¥',
  };

  final Map<String, int> _timeZones = {
    'WIB': 7,
    'WITA': 8,
    'WIT': 9,
    'London': 1,   // BST (British Summer Time)
    'New York': -4, // EDT (Eastern Daylight Time)
    'Tokyo': 9,
    'Seoul': 9,
  };

  // Flag Emoji untuk tiap zona waktu
  final Map<String, String> _tzFlags = {
    'WIB': '🇮🇩', 
    'WITA': '🇮🇩', 
    'WIT': '🇮🇩',
    'London': '🇬🇧', 
    'New York': '🇺🇸',
    'Tokyo': '🇯🇵', 
    'Seoul': '🇰🇷',
  };

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _amountCtrl.addListener(() => setState(() {}));
    _fetchLiveRates(); // Panggil API saat pertama buka
  }

  // FUNGSI UNTUK MENGAMBIL DATA API
  Future<void> _fetchLiveRates() async {
    setState(() => _isLoading = true);
    
    // Mengambil API Key dari file .env
    final apiKey = dotenv.env['EXCHANGE_RATE_API_KEY'];
    final url = Uri.parse('https://v6.exchangerate-api.com/v6/$apiKey/latest/IDR');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final Map<String, dynamic> apiRates = data['conversion_rates'];
        
        setState(() {
          // Update nilai _rates hanya untuk mata uang yang ada di list kita
          _rates.keys.forEach((key) {
            if (apiRates.containsKey(key)) {
              _rates[key] = apiRates[key]!.toDouble();
            }
          });
        });
      }
    } catch (e) {
      debugPrint('Error fetching rates: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _convertAmount(String toCurrency) {
    double baseAmount = double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0;
    // Rumus: (Jumlah / Rate Mata Uang Dasar) * Rate Mata Uang Tujuan
    final converted = (baseAmount / _rates[_baseCurrency]!) * _rates[toCurrency]!;
    
    if (toCurrency == 'IDR') return 'Rp ${_formatNumber(converted)}';
    return '${_currencySymbols[toCurrency]} ${converted > 1000 ? _formatNumber(converted) : converted.toStringAsFixed(2)}';
  }

  String _formatNumber(double n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(2)}M';
    return n.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: const Text('Converter'),
        actions: [
          // Tambahkan tombol refresh di pojok kanan atas
          IconButton(
            icon: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent))
                : const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchLiveRates,
          )
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppColors.accent,
          tabs: const [
            Tab(icon: Icon(Icons.currency_exchange_rounded, size: 18), text: 'Currency'),
            Tab(icon: Icon(Icons.schedule_rounded, size: 18), text: 'Time Zones'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          // Bungkus tab currency dengan Stack untuk menampilkan loading overlay jika perlu
          _isLoading 
            ? const Center(child: CircularProgressIndicator(color: AppColors.accent)) 
            : _buildCurrencyTab(), 
          _buildTimeTab()
        ],
      ),
    );
  }

  // Mendapatkan jam saat ini berdasarkan offset
  String _getTime(int offsetHours) {
    final utcNow = DateTime.now().toUtc();
    final local = utcNow.add(Duration(hours: offsetHours));
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  // Mendapatkan nama hari (Singkat)
  String _getDay(int offsetHours) {
    final utcNow = DateTime.now().toUtc();
    final local = utcNow.add(Duration(hours: offsetHours));
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[local.weekday - 1];
  }

  Widget _buildCurrencyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Context banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accentLight, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: const [
                Text('💄', style: TextStyle(fontSize: 20)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Check product prices in different currencies before buying imported beauty items!',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Input card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8A598), Color(0xFFA87890)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${_currencyFlags[_baseCurrency]} From',
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: _baseCurrency,
                      dropdownColor: AppColors.accentDark,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 18),
                      items: _rates.keys.map((c) => DropdownMenuItem(
                        value: c,
                        child: Text('${_currencyFlags[c]} $c',
                            style: const TextStyle(color: Colors.white, fontSize: 12)),
                      )).toList(),
                      onChanged: (v) => setState(() => _baseCurrency = v!),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _currencySymbols[_baseCurrency]!,
                      style: const TextStyle(fontSize: 22, color: Colors.white70, fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        controller: _amountCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                          hintText: '0',
                          hintStyle: TextStyle(color: Colors.white38, fontSize: 32),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Results grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
            ),
            itemCount: _rates.keys.where((c) => c != _baseCurrency).length,
            itemBuilder: (context, index) {
              final currencies = _rates.keys.where((c) => c != _baseCurrency).toList();
              final currency = currencies[index];
              return InfoCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_currencyFlags[currency]} $currency',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _convertAmount(currency),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Context examples
          SectionHeader(title: 'Popular Products'),
          const SizedBox(height: 10),
          ...[
            _ProductPrice('MAC Lipstick', 'USA', 'USD', 21.0),
            _ProductPrice('Fenty Beauty Foundation', 'USA', 'USD', 38.0),
            _ProductPrice('Laneige Lip Mask', 'Korea', 'KRW', 18000.0),
          ].map((p) => _buildProductPriceRow(p)),
        ],
      ),
    );
  }

  Widget _buildProductPriceRow(_ProductPrice p) {
    final idr = p.price / _rates[p.currency]!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InfoCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            const Text('💄', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text('From ${p.origin} · ${_currencySymbols[p.currency]}${p.price.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                ],
              ),
            ),
            Text(
              'Rp ${_formatNumber(idr)}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.accentDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.secondaryLight, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: const [
                Text('🕐', style: TextStyle(fontSize: 20)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Check international store opening hours & flash sale times across time zones!',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Indonesia time zones highlight
          SectionHeader(title: 'Indonesia Time Zones'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: ['WIB', 'WITA', 'WIT'].map((tz) {
                return Expanded(
                  child: Column(
                    children: [
                      Text(_tzFlags[tz]!, style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 6),
                      Text(
                        _getTime(_timeZones[tz]!),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentDark,
                        ),
                      ),
                      Text(
                        tz,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      Text(
                        _getDay(_timeZones[tz]!),
                        style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // World clocks
          SectionHeader(title: 'International Stores'),
          const SizedBox(height: 10),
          ...['London', 'New York', 'Tokyo', 'Seoul'].map((tz) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InfoCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Text(_tzFlags[tz] ?? '🌍', style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tz, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text(
                            _getStoreInfo(tz),
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _getTime(_timeZones[tz]!),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getDay(_timeZones[tz]!),
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          // Flash Sale Checker
          SectionHeader(title: 'Flash Sale Converter'),
          const SizedBox(height: 10),
          InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PastelBadge(label: '🛍️ Sephora US Flash Sale'),
                const SizedBox(height: 10),
                const Text('Sale starts at 8:00 PM EST (New York)',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: ['WIB', 'WITA', 'WIT', 'London'].map((tz) {
                    // Flash sale: 8PM EST = UTC+0 00:00, add timezone offset
                    final saleUtc = DateTime.utc(2025, 1, 1, 0, 0);
                    final localSale = saleUtc.add(Duration(hours: _timeZones[tz]!));
                    final h = localSale.hour.toString().padLeft(2, '0');
                    final m = localSale.minute.toString().padLeft(2, '0');
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.bgMuted,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(_tzFlags[tz] ?? '', style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(tz, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
                              Text('$h:$m', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.accentDark)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStoreInfo(String tz) {
    switch (tz) {
      case 'London': return 'Charlotte Tilbury · Boots';
      case 'New York': return 'Sephora US · Ulta Beauty';
      case 'Tokyo': return 'Shiseido · NARS Japan';
      case 'Seoul': return 'Innisfree · Laneige · 3CE';
      default: return '';
    }
  }
}

class _ProductPrice {
  final String name, origin, currency;
  final double price;
  const _ProductPrice(this.name, this.origin, this.currency, this.price);
}
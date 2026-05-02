import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isTyping = false;

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      isBot: true,
      text: 'Hii! Aku ChromaBot 🌸 Asisten kecantikan personalmu! Berdasarkan analisis warnamu, kamu termasuk tipe Warm Autumn yang cantik. Tanyakan apa saja soal makeup, outfit, atau warna yang cocok untukmu!',
      time: '09:00',
    ),
  ];

  final List<String> _quickReplies = [
    '💄 Rekomendasi lipstik untukku',
    '👗 Warna baju yang cocok',
    '💍 Aksesoris terbaik',
    '🛍️ Produk lokal yang cocok',
    '🎨 Jelaskan tipe warnaku',
  ];

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    _msgCtrl.clear();
    setState(() {
      _messages.add(_ChatMessage(isBot: false, text: text, time: _nowTime()));
      _isTyping = true;
    });
    _scrollToBottom();

    // Simulate API delay (replace with real Claude API call)
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    setState(() {
      _isTyping = false;
      _messages.add(_ChatMessage(
        isBot: true,
        text: _getMockResponse(text),
        time: _nowTime(),
      ));
    });
    _scrollToBottom();
  }

  String _getMockResponse(String query) {
    final q = query.toLowerCase();
    if (q.contains('lipstik') || q.contains('lip')) {
      return 'Untuk Warm Autumn seperti kamu, pilih lipstik dengan nada hangat! 💋\n\n• **Terracotta** — warna ikonik untuk warm autumn\n• **Brick Rose** — elegan dan natural\n• **Warm Berry** — sempurna untuk acara\n• **Nude Peach** — cocok sehari-hari\n\nHindari lipstik pink terang atau cool-toned ya, bisa bikin wajahmu terlihat pucat! 😊';
    } else if (q.contains('baju') || q.contains('outfit') || q.contains('warna baju')) {
      return 'Untuk outfit, warna yang paling cocok untuk Warm Autumn kamu: 👗\n\n• Earth tones: Terracotta, Sienna, Rust\n• Hijau: Olive, Moss, Forest Green\n• Netral hangat: Camel, Cream, Warm Brown\n• Aksen: Burgundy, Deep Red\n\nTips: Ratio 60-30-10 ya! 60% warna netral, 30% main color, 10% accent! ✨';
    } else if (q.contains('aksesoris') || q.contains('aksesori') || q.contains('perhiasan')) {
      return 'Pilihan aksesoris untuk undertone hangat kamu: 💍\n\n**Logam:**\n• ✅ Gold — paling sempurna!\n• ✅ Rose Gold — feminin dan hangat\n• ❌ Silver — terlalu dingin untuk undertone-mu\n\n**Gaya:**\n• Minimal & dainty lebih cocok\n• Bentuk organik & rounded\n• Hindari yang chunky atau sharp edges';
    } else if (q.contains('lokal') || q.contains('produk')) {
      return 'Produk lokal Indonesia yang cocok untuk Warm Autumn: 🇮🇩\n\n• **Wardah** — Lip Matte 19 Brick Red, 26 Plum Berry\n• **Sariayu** — Colour Trend Jogja series (earth tones!)\n• **Emina** — Cheek Lit Blush Peach Sorbet\n• **BLP Beauty** — Lip Coat Brick\n\nSemua tersedia di toko sekitar Yogyakarta! Mau aku bantu cari lokasi tokonya? 📍';
    } else {
      return 'Sebagai Warm Autumn, kamu punya undertone hangat keemasan yang cantik! 🍂\n\nIni artinya:\n• Kulit: Golden, warm beige\n• Mata: Warm brown to hazel\n• Warna terbaik: Earth tones, muted warm hues\n• Musim analog: Autumn dengan daun gugur\n\nKamu akan bersinar dengan warna-warna hangat dan muted! Ada yang ingin kamu tanyakan lebih lanjut? 😊';
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _nowTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text('🤖', style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ChromaBot', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                Row(children: [
                  Container(
                    width: 6, height: 6,
                    decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 4),
                  const Text('Online', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w400)),
                ]),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => setState(() {
              _messages.clear();
              _messages.add(_ChatMessage(
                isBot: true,
                text: 'Hii lagi! Ada yang bisa ChromaBot bantu? 🌸',
                time: _nowTime(),
              ));
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Context Banner ──
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.swatchTerracotta.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.swatchTerracotta.withOpacity(0.2)),
            ),
            child: Row(
              children: const [
                Text('🍂', style: TextStyle(fontSize: 14)),
                SizedBox(width: 8),
                Text(
                  'Saran berdasarkan palette: Warm Autumn',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── Messages ──
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // ── Quick Replies ──
          if (_messages.length <= 2)
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _quickReplies.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _sendMessage(_quickReplies[index]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        _quickReplies[index],
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 8),

          // ── Input Bar ──
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.borderLight, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration(
                      hintText: 'Tanya ChromaBot...',
                      fillColor: AppColors.bgSurface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(99),
                        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _sendMessage(_msgCtrl.text),
                  child: Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: msg.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (msg.isBot) ...[
            Container(
              width: 28, height: 28,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('🤖', style: TextStyle(fontSize: 14))),
            ),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: msg.isBot ? AppColors.bgCard : AppColors.accent,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(msg.isBot ? 4 : 16),
                      bottomRight: Radius.circular(msg.isBot ? 16 : 4),
                    ),
                    border: msg.isBot ? Border.all(color: AppColors.borderLight, width: 0.5) : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 13,
                      color: msg.isBot ? AppColors.textPrimary : Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  msg.time,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          if (!msg.isBot) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: Text('🤖', style: TextStyle(fontSize: 14))),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppColors.borderLight, width: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedOpacity(
                  opacity: 0.4 + (i * 0.2),
                  duration: Duration(milliseconds: 400 + (i * 150)),
                  child: Container(
                    width: 7, height: 7,
                    margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final bool isBot;
  final String text;
  final String time;
  const _ChatMessage({required this.isBot, required this.text, required this.time});
}
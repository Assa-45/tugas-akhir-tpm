import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  int _score = 0;
  int _streak = 0;
  int _timeLeft = 30;
  int _questionIndex = 0;
  int? _selectedOption;
  bool _answered = false;
  bool _gameOver = false;
  Timer? _timer;
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  final List<_Question> _questions = [
    _Question(
      skinTone: 'Warm undertone — golden glow',
      skinEmoji: '🌟',
      skinGradient: [Color(0xFFE8C4A0), Color(0xFFD4A06A)],
      question: 'Best lip color for this skin tone?',
      options: [
        _Option(color: Color(0xFFD4785A), name: 'Terracotta', isCorrect: true),
        _Option(color: Color(0xFFD4B4E8), name: 'Lavender', isCorrect: false),
        _Option(color: Color(0xFFFF6B8A), name: 'Hot Pink', isCorrect: false),
        _Option(color: Color(0xFFA8D4B8), name: 'Mint', isCorrect: false),
      ],
    ),
    _Question(
      skinTone: 'Cool undertone — rosy pink',
      skinEmoji: '🌸',
      skinGradient: [Color(0xFFF0D0D8), Color(0xFFD4A0B0)],
      question: 'Best blush for this skin tone?',
      options: [
        _Option(color: Color(0xFFE890C0), name: 'Rose Pink', isCorrect: true),
        _Option(color: Color(0xFFC9825A), name: 'Terracotta', isCorrect: false),
        _Option(color: Color(0xFFD4A76A), name: 'Camel', isCorrect: false),
        _Option(color: Color(0xFF8B4513), name: 'Sienna', isCorrect: false),
      ],
    ),
    _Question(
      skinTone: 'Warm autumn — deep & muted',
      skinEmoji: '🍂',
      skinGradient: [Color(0xFFC4A882), Color(0xFF8B6040)],
      question: 'Best eyeshadow palette?',
      options: [
        _Option(color: Color(0xFF8B6248), name: 'Mocha Brown', isCorrect: true),
        _Option(color: Color(0xFFB8D0FF), name: 'Periwinkle', isCorrect: false),
        _Option(color: Color(0xFFE8A0C0), name: 'Baby Rose', isCorrect: false),
        _Option(color: Color(0xFFA0D4D8), name: 'Teal Mist', isCorrect: false),
      ],
    ),
    _Question(
      skinTone: 'Cool summer — soft & muted',
      skinEmoji: '🌊',
      skinGradient: [Color(0xFFD0DCF0), Color(0xFFA0B8D8)],
      question: 'Best outfit color combo?',
      options: [
        _Option(color: Color(0xFF8090C0), name: 'Dusty Blue', isCorrect: true),
        _Option(color: Color(0xFFC9825A), name: 'Terracotta', isCorrect: false),
        _Option(color: Color(0xFFD4A76A), name: 'Warm Gold', isCorrect: false),
        _Option(color: Color(0xFF8B4513), name: 'Deep Brown', isCorrect: false),
      ],
    ),
  ];

  _Question get _current => _questions[_questionIndex % _questions.length];

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = Tween<double>(begin: 0, end: 8)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeCtrl);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft <= 0) {
        t.cancel();
        setState(() => _gameOver = true);
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
    });

    if (_current.options[index].isCorrect) {
      setState(() {
        _score += 10 + (_streak * 2);
        _streak++;
      });
    } else {
      _streak = 0;
      _shakeCtrl.forward(from: 0);
    }

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _questionIndex++;
        _selectedOption = null;
        _answered = false;
      });
    });
  }

  void _restartGame() {
    _timer?.cancel();
    setState(() {
      _score = 0;
      _streak = 0;
      _timeLeft = 30;
      _questionIndex = 0;
      _selectedOption = null;
      _answered = false;
      _gameOver = false;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: const Text('ColorMatch'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: _gameOver ? _buildGameOver() : _buildGame(),
    );
  }

  Widget _buildGame() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // ── Stats Row ──
          Row(
            children: [
              _StatPill(icon: '⭐', value: '$_score', label: 'Score'),
              const SizedBox(width: 10),
              _StatPill(icon: '🔥', value: '$_streak', label: 'Streak'),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _timeLeft < 10 ? AppColors.errorLight : AppColors.bgCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: _timeLeft < 10 ? AppColors.error : AppColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$_timeLeft',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _timeLeft < 10 ? AppColors.error : AppColors.textPrimary,
                        ),
                      ),
                      const Text('sec', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Progress Bar ──
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: _timeLeft / 30.0,
              backgroundColor: AppColors.bgMuted,
              valueColor: AlwaysStoppedAnimation<Color>(
                  _timeLeft < 10 ? AppColors.error : AppColors.accent),
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 24),

          // ── Skin Tone Display ──
          AnimatedBuilder(
            animation: _shakeAnim,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnim.value * (_shakeCtrl.status == AnimationStatus.forward ? 1 : -1), 0),
                child: child,
              );
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _current.skinGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _current.skinGradient[1].withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: Center(
                child: Text(_current.skinEmoji, style: const TextStyle(fontSize: 40)),
              ),
            ),
          ),

          const SizedBox(height: 12),

          PastelBadge(
            label: _current.skinTone,
            color: AppColors.secondaryLight,
            textColor: AppColors.accentDark,
          ),

          const SizedBox(height: 12),

          Text(
            _current.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // ── Options Grid ──
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
            ),
            itemCount: _current.options.length,
            itemBuilder: (context, index) {
              final option = _current.options[index];
              Color borderColor = AppColors.border;
              Color bgColor = AppColors.bgCard;

              if (_answered && _selectedOption == index) {
                if (option.isCorrect) {
                  borderColor = AppColors.success;
                  bgColor = AppColors.successLight;
                } else {
                  borderColor = AppColors.error;
                  bgColor = AppColors.errorLight;
                }
              } else if (_answered && option.isCorrect) {
                borderColor = AppColors.success;
                bgColor = AppColors.successLight;
              }

              return GestureDetector(
                onTap: () => _selectOption(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: option.color,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: option.color.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          option.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (_answered && option.isCorrect)
                        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                      if (_answered && _selectedOption == index && !option.isCorrect)
                        const Icon(Icons.cancel_rounded, color: AppColors.error, size: 16),
                    ],
                  ),
                ),
              );
            },
          ),

          const Spacer(),

          // Bottom hint
          if (_streak >= 3)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                '🔥 $_streak streak! +${_streak * 2} bonus per answer',
                style: const TextStyle(fontSize: 11, color: AppColors.primaryDark, fontWeight: FontWeight.w500),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGameOver() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryLight, AppColors.accentLight],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('🎉', style: TextStyle(fontSize: 48))),
            ),
            const SizedBox(height: 20),
            const Text('Time\'s Up!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text('You scored $_score points',
                style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            InfoCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _FinalStat(value: '$_score', label: 'Final Score'),
                  Container(width: 0.5, height: 40, color: AppColors.border),
                  _FinalStat(value: '$_questionIndex', label: 'Questions'),
                  Container(width: 0.5, height: 40, color: AppColors.border),
                  _FinalStat(value: '${(_score / (_questionIndex * 10) * 100).clamp(0, 100).toInt()}%', label: 'Accuracy'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _restartGame,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Play Again'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.leaderboard_outlined),
                label: const Text('View Leaderboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String icon, value, label;
  const _StatPill({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.accentDark)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ]),
    );
  }
}

class _FinalStat extends StatelessWidget {
  final String value, label;
  const _FinalStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.accentDark)),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
    ]);
  }
}

class _Question {
  final String skinTone, skinEmoji, question;
  final List<Color> skinGradient;
  final List<_Option> options;
  const _Question({required this.skinTone, required this.skinEmoji, required this.skinGradient, required this.question, required this.options});
}

class _Option {
  final Color color;
  final String name;
  final bool isCorrect;
  const _Option({required this.color, required this.name, required this.isCorrect});
}
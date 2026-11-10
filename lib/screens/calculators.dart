import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/facts.dart';
import '../core/format.dart';
import '../core/orbits.dart';
import '../data/planets.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/motion.dart';
import 'birthday_screen.dart';

/// What the user would weigh, how high they could jump and how old they would
/// be on other worlds. Shown at the bottom of the Compare tab.
class Calculators extends StatefulWidget {
  const Calculators({super.key});

  @override
  State<Calculators> createState() => _CalculatorsState();
}

class _CalculatorsState extends State<Calculators> {
  final TextEditingController _controller = TextEditingController(text: '70');
  double _kg = 70;
  final TextEditingController _jumpController =
      TextEditingController(text: '40');
  double _jumpCm = 40;

  @override
  void dispose() {
    _controller.dispose();
    _jumpController.dispose();
    super.dispose();
  }

  void _changed(String text) {
    final value = double.tryParse(text.replaceAll(',', '.'));
    setState(() => _kg = (value == null || value < 0) ? 0 : value);
  }

  void _jumpChanged(String text) {
    final value = double.tryParse(text.replaceAll(',', '.'));
    setState(() => _jumpCm = (value == null || value < 0) ? 0 : value);
  }

  InputDecoration _decoration(Palette p, String label, String suffix) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: width),
        );
    return InputDecoration(
      labelText: label,
      suffixText: suffix,
      filled: true,
      fillColor: p.surface,
      border: border(p.border),
      enabledBorder: border(p.border),
      focusedBorder: border(p.accentText, 1.5),
    );
  }


  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(l.weightTitle,
            style: TextStyle(fontFamily: headingFont, fontSize: 22, fontWeight: FontWeight.w700, color: p.text)),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          onChanged: _changed,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            LengthLimitingTextInputFormatter(6),
          ],
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: p.text),
          decoration: _decoration(p, l.weightInput, 'kg'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _jumpController,
          onChanged: _jumpChanged,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            LengthLimitingTextInputFormatter(5),
          ],
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: p.text),
          decoration: _decoration(p, l.jumpInput, 'cm'),
        ),
        const SizedBox(height: 6),
        Text(l.jumpNote, style: TextStyle(fontSize: 12, color: p.muted)),
        const SizedBox(height: 16),
        for (final planet in allBodies) ...<Widget>[
          FadeSlideIn(child: SurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            borderColor: planet.id == 'earth' ? p.accentText : null,
            child: Row(
              children: <Widget>[
                PlanetBall(planet: planet, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(planetName(l, planet),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: p.text)),
                      Text(
                        '${l.gravityTimes(formatNumber(context, planet.relativeGravity, decimals: 2))}'
                        ' · ${l.jumpHigh(jumpText(context, l, jumpHeightCm(_jumpCm, planet.relativeGravity)))}',
                        style: TextStyle(fontSize: 12, color: p.muted),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${formatNumber(context, planet.weightFor(_kg), decimals: 1)} kg',
                  style: TextStyle(fontFamily: headingFont, fontSize: 18, fontWeight: FontWeight.w700,
                    color: p.accentText,
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 24),
        const FadeSlideIn(child: _AgeSection()),
      ],
    );
  }
}

/// "Your age on other planets": the user's age in each planet's years, a live
/// cosmic odometer since birth, next planetary birthday highlight, and the days
/// until their next birthday on every world.
class _AgeSection extends StatefulWidget {
  const _AgeSection();

  /// Bodies with a year around the Sun: the planets and Pluto.
  static final List<Planet> _bodies = <Planet>[
    ...planets,
    planetById('pluto'),
  ];

  @override
  State<_AgeSection> createState() => _AgeSectionState();
}

class _AgeSectionState extends State<_AgeSection> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _pick(BuildContext context, DateTime? current) async {
    final state = AppScope.read(context);
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      await state.setBirthDate(
          DateTime(picked.year, picked.month, picked.day, 12));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isHi = Localizations.localeOf(context).languageCode == 'hi';
    final p = Palette.of(context);
    final saved = AppScope.of(context).settings.birthDate;
    final now = DateTime.now();
    final DateTime? birth =
        saved != null && saved.isBefore(now) ? saved : null;

    Planet? nextBdayPlanet;
    var minDaysToBday = 999999;
    var nextAgeTurn = 1;
    if (birth != null) {
      for (final body in _AgeSection._bodies) {
        final d = daysToNextBirthday(birth, now, body.yearDays);
        if (d < minDaysToBday) {
          minDaysToBday = d;
          nextBdayPlanet = body;
          nextAgeTurn = ageOn(birth, now, body.yearDays).floor() + 1;
        }
      }
    }

    final secsAlive = birth == null
        ? 0.0
        : now.difference(birth).inMilliseconds / 1000.0;
    // Earth orbital speed ~29.78 km/s; Solar System galactic orbit ~220 km/s
    final solarKm = secsAlive * 29.78;
    final galacticKm = secsAlive * 220.0;
    final fullMoons = secsAlive / (29.53059 * 86400.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(l.ageTitle,
            style: TextStyle(
                fontFamily: headingFont,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: p.text)),
        const SizedBox(height: 12),
        SurfaceCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: <Widget>[
              Icon(Icons.cake_outlined, color: p.accentText),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  birth != null
                      ? MaterialLocalizations.of(context)
                          .formatMediumDate(birth)
                      : l.setBirthDate,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600, color: p.text),
                ),
              ),
              TextButton(
                onPressed: () => _pick(context, birth),
                child:
                    Text(birth != null ? l.changeBirthDate : l.setBirthDate),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(l.ageNote, style: TextStyle(fontSize: 12, color: p.muted)),
        if (birth != null) ...<Widget>[
          const SizedBox(height: 12),
          // 1. Live Cosmic Odometer Card
          SurfaceCard(
            borderColor: p.accent.withValues(alpha: 0.45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.rocket_launch_outlined,
                        size: 18, color: p.accentText),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isHi
                            ? 'आपका लाइव अंतरिक्ष सफ़र (जन्म से अब तक)'
                            : 'Your live cosmic journey since birth',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: p.accentText),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${formatNumber(context, solarKm / 1e6, decimals: 3)} ${isHi ? "मिलियन किमी" : "million km"}',
                  style: TextStyle(
                    fontFamily: headingFont,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: p.text,
                  ),
                ),
                Text(
                  isHi
                      ? 'पृथ्वी के साथ सूर्य की परिक्रमा करते हुए (29.78 km/s)'
                      : 'Travelled around the Sun aboard Earth (29.78 km/s)',
                  style: TextStyle(fontSize: 12, color: p.muted),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${formatNumber(context, galacticKm / 1e9, decimals: 3)} ${isHi ? "अरब किमी" : "billion km"}',
                            style: TextStyle(
                                fontFamily: headingFont,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: p.text),
                          ),
                          Text(
                            isHi
                                ? 'आकाशगंगा (Milky Way) में सफ़र'
                                : 'Through the Milky Way (220 km/s)',
                            style: TextStyle(fontSize: 11.5, color: p.muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            formatNumber(context, fullMoons, decimals: 1),
                            style: TextStyle(
                                fontFamily: headingFont,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: p.text),
                          ),
                          Text(
                            isHi
                                ? 'चाँद की परिक्रमाएँ (Full Moons)'
                                : 'Lunar orbits experienced',
                            style: TextStyle(fontSize: 11.5, color: p.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 2. Next Planetary Birthday Countdown Highlight
          if (nextBdayPlanet != null) ...<Widget>[
            const SizedBox(height: 12),
            SurfaceCard(
              child: Row(
                children: <Widget>[
                  PlanetBall(planet: nextBdayPlanet, size: 42),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          isHi
                              ? 'अगला अंतरिक्ष जन्मदिन: ${planetName(l, nextBdayPlanet)}'
                              : 'Next space birthday: ${planetName(l, nextBdayPlanet)}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: p.text),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isHi
                              ? '${planetName(l, nextBdayPlanet)} पर आप $minDaysToBday दिन में $nextAgeTurn वर्ष के होंगे!'
                              : 'You turn $nextAgeTurn on ${planetName(l, nextBdayPlanet)} in $minDaysToBday days!',
                          style: TextStyle(fontSize: 13, color: p.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          SurfaceCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              leading: Icon(Icons.nights_stay_outlined, color: p.accentText),
              title: Text(l.birthdayTitle,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: p.text)),
              subtitle: Text(l.birthdayCardHint,
                  style: TextStyle(fontSize: 13, color: p.muted)),
              trailing: Icon(Icons.chevron_right, color: p.muted),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => const BirthdayScreen(),
              )),
            ),
          ),
          const SizedBox(height: 12),
          for (final body in _AgeSection._bodies) ...<Widget>[
            SurfaceCard(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              borderColor: body.id == 'earth' ? p.accentText : null,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      PlanetBall(planet: body, size: 32),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(planetName(l, body),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: p.text)),
                            Text(
                              l.nextBirthday(formatNumber(context,
                                  daysToNextBirthday(birth, now, body.yearDays))),
                              style: TextStyle(fontSize: 12, color: p.muted),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        l.valueYears(formatNumber(
                            context, ageOn(birth, now, body.yearDays),
                            decimals: body.yearDays > 3000 ? 3 : 1)),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: p.accentText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      minHeight: 4,
                      value: (ageOn(birth, now, body.yearDays) % 1.0)
                          .clamp(0.0, 1.0),
                      backgroundColor: p.surfaceHigh,
                      valueColor: AlwaysStoppedAnimation<Color>(body.color),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ],
    );
  }
}

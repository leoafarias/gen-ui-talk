import 'package:flutter/material.dart';

/// --------------------------------------
/// DATA MODEL: Enums + Options + Program
/// --------------------------------------

enum FoodPreset { pizza, cookies, chicken }

extension FoodPresetX on FoodPreset {
  String get label => switch (this) {
    FoodPreset.pizza => 'Pizza',
    FoodPreset.cookies => 'Cookies',
    FoodPreset.chicken => 'Chicken',
  };

  IconData get icon => switch (this) {
    FoodPreset.pizza => Icons.local_pizza,
    FoodPreset.cookies => Icons.cookie,
    FoodPreset.chicken => Icons.food_bank,
  };
}

// ---------- Pizza ----------
enum PizzaCrust { thin, regular, thick }

extension PizzaCrustX on PizzaCrust {
  String get label => switch (this) {
    PizzaCrust.thin => 'Thin',
    PizzaCrust.regular => 'Regular',
    PizzaCrust.thick => 'Thick',
  };
}

enum PizzaSize { personal, medium, large }

extension PizzaSizeX on PizzaSize {
  String get label => switch (this) {
    PizzaSize.personal => 'Personal',
    PizzaSize.medium => 'Medium',
    PizzaSize.large => 'Large',
  };
}

enum PizzaToppings { light, regular, extra }

extension PizzaToppingsX on PizzaToppings {
  String get label => switch (this) {
    PizzaToppings.light => 'Light',
    PizzaToppings.regular => 'Regular',
    PizzaToppings.extra => 'Extra',
  };
}

// ---------- Cookies ----------
enum CookieType { chocolateChip, sugar, oatmeal }

extension CookieTypeX on CookieType {
  String get label => switch (this) {
    CookieType.chocolateChip => 'Choc Chip',
    CookieType.sugar => 'Sugar',
    CookieType.oatmeal => 'Oatmeal',
  };
}

enum CookieTexture { soft, crispy }

extension CookieTextureX on CookieTexture {
  String get label => switch (this) {
    CookieTexture.soft => 'Soft',
    CookieTexture.crispy => 'Crispy',
  };
}

enum CookieBatch { b12, b24, b36 }

extension CookieBatchX on CookieBatch {
  int get count => switch (this) {
    CookieBatch.b12 => 12,
    CookieBatch.b24 => 24,
    CookieBatch.b36 => 36,
  };
  String get label => count.toString();
}

// ---------- Chicken ----------
enum ChickenCut { whole, pieces, wings }

extension ChickenCutX on ChickenCut {
  String get label => switch (this) {
    ChickenCut.whole => 'Whole',
    ChickenCut.pieces => 'Pieces',
    ChickenCut.wings => 'Wings',
  };
}

enum ChickenWeight { w4to5, w6to7, w8plus }

extension ChickenWeightX on ChickenWeight {
  String get label => switch (this) {
    ChickenWeight.w4to5 => '4-5 lbs',
    ChickenWeight.w6to7 => '6-7 lbs',
    ChickenWeight.w8plus => '8+ lbs',
  };
}

enum ChickenStyle { roasted, crispy, bbq }

extension ChickenStyleX on ChickenStyle {
  String get label => switch (this) {
    ChickenStyle.roasted => 'Roasted',
    ChickenStyle.crispy => 'Crispy',
    ChickenStyle.bbq => 'BBQ',
  };
}

// ---------- Options (sealed) ----------
sealed class FoodOptions {
  const FoodOptions();
}

class PizzaOptions extends FoodOptions {
  final PizzaCrust crust;
  final PizzaSize size;
  final PizzaToppings toppings;
  const PizzaOptions({
    this.crust = PizzaCrust.regular,
    this.size = PizzaSize.medium,
    this.toppings = PizzaToppings.regular,
  });

  PizzaOptions copyWith({
    PizzaCrust? crust,
    PizzaSize? size,
    PizzaToppings? toppings,
  }) => PizzaOptions(
    crust: crust ?? this.crust,
    size: size ?? this.size,
    toppings: toppings ?? this.toppings,
  );
}

class CookieOptions extends FoodOptions {
  final CookieType type;
  final CookieTexture texture;
  final CookieBatch batch;
  const CookieOptions({
    this.type = CookieType.chocolateChip,
    this.texture = CookieTexture.soft,
    this.batch = CookieBatch.b24,
  });

  CookieOptions copyWith({
    CookieType? type,
    CookieTexture? texture,
    CookieBatch? batch,
  }) => CookieOptions(
    type: type ?? this.type,
    texture: texture ?? this.texture,
    batch: batch ?? this.batch,
  );
}

class ChickenOptions extends FoodOptions {
  final ChickenCut cut;
  final ChickenWeight weight;
  final ChickenStyle style;
  const ChickenOptions({
    this.cut = ChickenCut.whole,
    this.weight = ChickenWeight.w4to5,
    this.style = ChickenStyle.roasted,
  });

  ChickenOptions copyWith({
    ChickenCut? cut,
    ChickenWeight? weight,
    ChickenStyle? style,
  }) => ChickenOptions(
    cut: cut ?? this.cut,
    weight: weight ?? this.weight,
    style: style ?? this.style,
  );
}

typedef OvenProgram = ({int temperatureC, int minutes});

OvenProgram computeProgram(FoodPreset preset, FoodOptions options) {
  if (preset == FoodPreset.pizza && options is PizzaOptions) {
    final crust = options.crust;
    final size = options.size;
    int temp = switch (crust) {
      PizzaCrust.thin => 260,
      PizzaCrust.regular => 245,
      PizzaCrust.thick => 230,
    };
    int minutes = switch (crust) {
      PizzaCrust.thin => 8,
      PizzaCrust.regular => 12,
      PizzaCrust.thick => 16,
    };
    switch (size) {
      case PizzaSize.personal:
        minutes -= 2;
        break;
      case PizzaSize.medium:
        break;
      case PizzaSize.large:
        minutes += 2;
        break;
    }
    return (temperatureC: temp, minutes: minutes);
  }

  if (preset == FoodPreset.cookies && options is CookieOptions) {
    final texture = options.texture;
    final batch = options.batch;
    final temp = texture == CookieTexture.crispy ? 180 : 175;
    var minutes = texture == CookieTexture.crispy ? 12 : 10;
    if (batch == CookieBatch.b36) {
      minutes += 2;
    }
    return (temperatureC: temp, minutes: minutes);
  }

  if (preset == FoodPreset.chicken && options is ChickenOptions) {
    final style = options.style;
    final cut = options.cut;
    final weight = options.weight;
    final temp = style == ChickenStyle.crispy ? 200 : 190;
    final minutes = switch (cut) {
      ChickenCut.whole => switch (weight) {
        ChickenWeight.w4to5 => 60,
        ChickenWeight.w6to7 => 75,
        ChickenWeight.w8plus => 90,
      },
      ChickenCut.pieces => 35,
      ChickenCut.wings => 25,
    };
    return (temperatureC: temp, minutes: minutes);
  }

  return (temperatureC: 180, minutes: 25);
}

FoodOptions defaultOptionsFor(FoodPreset preset) => switch (preset) {
  FoodPreset.pizza => const PizzaOptions(),
  FoodPreset.cookies => const CookieOptions(),
  FoodPreset.chicken => const ChickenOptions(),
};

/// --------------------------------------
/// UI: Shared pieces
/// --------------------------------------

const _mono = TextStyle(fontFamily: 'monospace');
TextStyle get _sectionTitle => const TextStyle(
  color: Colors.white70,
  fontSize: 12,
  fontWeight: FontWeight.w600,
  letterSpacing: 1,
).merge(_mono);

TextStyle get _labelStyle => const TextStyle(
  color: Colors.white54,
  fontSize: 10,
  letterSpacing: 0.5,
).merge(_mono);

TextStyle get _itemStyle =>
    const TextStyle(color: Colors.white, fontSize: 12).merge(_mono);

class GlassDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> values;
  final String Function(T) toLabel;
  final ValueChanged<T> onChanged;

  const GlassDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.values,
    required this.toLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: 4),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              dropdownColor: Colors.black.withOpacity(0.92),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
              style: _itemStyle,
              items: values
                  .map(
                    (v) => DropdownMenuItem<T>(
                      value: v,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(toLabel(v), style: _itemStyle),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class DisplayContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;

  const DisplayContainer({
    super.key,
    required this.child,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8),
        ],
      ),
      child: child,
    );
  }
}

class TouchControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isPower;
  final VoidCallback onTap;

  const TouchControlButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isPower = false,
  });

  @override
  Widget build(BuildContext context) {
    final glow = isPower ? Colors.red.shade400 : Colors.orange.shade400;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        splashColor: glow.withOpacity(0.30),
        highlightColor: glow.withOpacity(0.12),
        child: Container(
          width: 86,
          height: 60,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.black.withOpacity(0.9)
                : Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              if (isActive)
                BoxShadow(color: glow.withOpacity(0.45), blurRadius: 10),
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : Colors.grey.shade500,
                size: 22,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white70 : Colors.grey.shade500,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ).merge(_mono),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TemperatureDisplay extends StatelessWidget {
  final bool on;
  final int celsius;
  const TemperatureDisplay({
    super.key,
    required this.on,
    required this.celsius,
  });

  @override
  Widget build(BuildContext context) {
    return DisplayContainer(
      width: 100,
      height: 60,
      child: Center(
        child: Text(
          '$celsius°C',
          style: TextStyle(
            color: on ? Colors.white : Colors.grey.shade600,
            fontSize: 24,
            letterSpacing: 1,
          ).merge(_mono),
        ),
      ),
    );
  }
}

class TimerDisplay extends StatelessWidget {
  final bool on;
  final int minutes;
  const TimerDisplay({super.key, required this.on, required this.minutes});

  @override
  Widget build(BuildContext context) {
    final mm = minutes.toString().padLeft(2, '0');
    return DisplayContainer(
      width: 120,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer,
            color: on ? Colors.white : Colors.grey.shade600,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            '$mm:00',
            style: TextStyle(
              color: on ? Colors.white : Colors.grey.shade600,
              fontSize: 22,
              letterSpacing: 1,
            ).merge(_mono),
          ),
        ],
      ),
    );
  }
}

class DynamicFoodControls extends StatelessWidget {
  final FoodPreset preset;
  final FoodOptions options;
  final ValueChanged<FoodOptions> onChanged;

  const DynamicFoodControls({
    super.key,
    required this.preset,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return switch ((preset, options)) {
      (FoodPreset.pizza, final PizzaOptions o) => _PizzaControls(
        options: o,
        onChanged: onChanged,
      ),
      (FoodPreset.cookies, final CookieOptions o) => _CookieControls(
        options: o,
        onChanged: onChanged,
      ),
      (FoodPreset.chicken, final ChickenOptions o) => _ChickenControls(
        options: o,
        onChanged: onChanged,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _PizzaControls extends StatelessWidget {
  final PizzaOptions options;
  final ValueChanged<PizzaOptions> onChanged;
  const _PizzaControls({required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'PIZZA SETTINGS',
      children: [
        _ControlRow(
          children: [
            GlassDropdown<PizzaCrust>(
              label: 'CRUST',
              value: options.crust,
              values: PizzaCrust.values,
              toLabel: (v) => v.label,
              onChanged: (v) => onChanged(options.copyWith(crust: v)),
            ),
            GlassDropdown<PizzaSize>(
              label: 'SIZE',
              value: options.size,
              values: PizzaSize.values,
              toLabel: (v) => v.label,
              onChanged: (v) => onChanged(options.copyWith(size: v)),
            ),
            GlassDropdown<PizzaToppings>(
              label: 'TOPPINGS',
              value: options.toppings,
              values: PizzaToppings.values,
              toLabel: (v) => v.label,
              onChanged: (v) => onChanged(options.copyWith(toppings: v)),
            ),
          ],
        ),
      ],
    );
  }
}

class _CookieControls extends StatelessWidget {
  final CookieOptions options;
  final ValueChanged<CookieOptions> onChanged;
  const _CookieControls({required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'COOKIE SETTINGS',
      children: [
        _ControlRow(
          children: [
            GlassDropdown<CookieType>(
              label: 'TYPE',
              value: options.type,
              values: CookieType.values,
              toLabel: (v) => v.label,
              onChanged: (v) => onChanged(options.copyWith(type: v)),
            ),
            GlassDropdown<CookieTexture>(
              label: 'TEXTURE',
              value: options.texture,
              values: CookieTexture.values,
              toLabel: (v) => v.label,
              onChanged: (v) => onChanged(options.copyWith(texture: v)),
            ),
            GlassDropdown<CookieBatch>(
              label: 'BATCH',
              value: options.batch,
              values: CookieBatch.values,
              toLabel: (v) => v.label,
              onChanged: (v) => onChanged(options.copyWith(batch: v)),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChickenControls extends StatelessWidget {
  final ChickenOptions options;
  final ValueChanged<ChickenOptions> onChanged;
  const _ChickenControls({required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'CHICKEN SETTINGS',
      children: [
        _ControlRow(
          children: [
            GlassDropdown<ChickenCut>(
              label: 'CUT',
              value: options.cut,
              values: ChickenCut.values,
              toLabel: (v) => v.label,
              onChanged: (v) => onChanged(options.copyWith(cut: v)),
            ),
            GlassDropdown<ChickenWeight>(
              label: 'WEIGHT',
              value: options.weight,
              values: ChickenWeight.values,
              toLabel: (v) => v.label,
              onChanged: (v) => onChanged(options.copyWith(weight: v)),
            ),
            GlassDropdown<ChickenStyle>(
              label: 'STYLE',
              value: options.style,
              values: ChickenStyle.values,
              toLabel: (v) => v.label,
              onChanged: (v) => onChanged(options.copyWith(style: v)),
            ),
          ],
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: _sectionTitle),
        const SizedBox(height: 14),
        ...children,
      ],
    );
  }
}

class _ControlRow extends StatelessWidget {
  final List<Widget> children;
  const _ControlRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTight = constraints.maxWidth < 480;
        final items = children
            .map(
              (w) => isTight
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: w,
                      ),
                    )
                  : SizedBox(width: 160, child: w),
            )
            .toList();
        return isTight
            ? Column(children: items)
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: items,
              );
      },
    );
  }
}

class ModernOvenPanel extends StatelessWidget {
  final bool poweredOn;
  final FoodPreset preset;
  final FoodOptions options;
  final VoidCallback onTogglePower;
  final ValueChanged<FoodOptions> onOptionsChanged;

  const ModernOvenPanel({
    super.key,
    required this.poweredOn,
    required this.preset,
    required this.options,
    required this.onTogglePower,
    required this.onOptionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final program = computeProgram(preset, options);

    return Container(
      width: 600,
      height: 400,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.4),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.90),
                        Color.fromRGBO(0, 0, 0, 0.95),
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(255, 255, 255, 0.12),
                              Colors.transparent,
                              Color.fromRGBO(0, 0, 0, 0.2),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            3,
                            (i) => Row(
                              children: [
                                _rackEnd(),
                                Expanded(child: _rackBar()),
                                _rackEnd(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (poweredOn)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 100,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.orange.shade900.withOpacity(0.30),
                                  Colors.orange.shade800.withOpacity(0.10),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 40,
                  right: 40,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.40),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.30),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DynamicFoodControls(
                      preset: preset,
                      options: options,
                      onChanged: onOptionsChanged,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.grey.shade400,
                            Colors.grey.shade700,
                            Colors.grey.shade800,
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.4),
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(255, 255, 255, 0.1),
                            blurRadius: 2,
                            offset: Offset(0, -1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TouchControlButton(
                          icon: Icons.power_settings_new,
                          label: 'POWER',
                          isActive: poweredOn,
                          isPower: true,
                          onTap: onTogglePower,
                        ),
                        const SizedBox(width: 14),
                        TemperatureDisplay(
                          on: poweredOn,
                          celsius: program.temperatureC,
                        ),
                        const SizedBox(width: 8),
                        TimerDisplay(on: poweredOn, minutes: program.minutes),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rackEnd() => Container(
    width: 20,
    height: 3,
    decoration: BoxDecoration(
      color: Colors.grey.shade600,
      borderRadius: BorderRadius.circular(2),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.5),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
  );

  Widget _rackBar() => Container(
    height: 2,
    margin: const EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      color: Colors.grey.shade700,
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.5),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
  );
}

class FoodSelectionBar extends StatelessWidget {
  final FoodPreset selected;
  final ValueChanged<FoodPreset> onChanged;
  const FoodSelectionBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget item(FoodPreset p) {
      final active = p == selected;
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => onChanged(p),
          borderRadius: BorderRadius.circular(8),
          splashColor: Colors.orange.shade400.withOpacity(0.3),
          highlightColor: Colors.orange.shade400.withOpacity(0.1),
          child: Container(
            width: 110,
            height: 50,
            decoration: BoxDecoration(
              color: active ? Colors.orange.shade800 : Colors.grey.shade800,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                if (active)
                  BoxShadow(
                    color: Colors.orange.shade400.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  p.icon,
                  color: active ? Colors.white : Colors.grey.shade400,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  p.label.toUpperCase(),
                  style: TextStyle(
                    color: active ? Colors.white : Colors.grey.shade400,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ).merge(_mono),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        item(FoodPreset.pizza),
        const SizedBox(width: 8),
        item(FoodPreset.cookies),
        const SizedBox(width: 8),
        item(FoodPreset.chicken),
      ],
    );
  }
}

class SmartOven extends StatefulWidget {
  final FoodPreset? preset;
  const SmartOven({super.key, this.preset});

  @override
  State<SmartOven> createState() => _SmartOvenState();
}

class _SmartOvenState extends State<SmartOven> {
  late bool _poweredOn;
  late FoodPreset _preset;
  late FoodOptions _options;

  @override
  void initState() {
    super.initState();
    _poweredOn = false;
    _preset = widget.preset ?? FoodPreset.pizza;
    _options = defaultOptionsFor(_preset);
  }

  @override
  void didUpdateWidget(covariant SmartOven oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.preset != null && widget.preset != oldWidget.preset) {
      setState(() {
        _preset = widget.preset!;
        _options = defaultOptionsFor(_preset);
      });
    }
  }

  void _togglePower() {
    setState(() {
      _poweredOn = !_poweredOn;
      if (!_poweredOn) {
        _options = defaultOptionsFor(_preset);
      }
    });
  }

  void _changePreset(FoodPreset p) {
    setState(() {
      _preset = p;
      _options = defaultOptionsFor(p);
    });
  }

  void _changeOptions(FoodOptions newOptions) {
    setState(() => _options = newOptions);
  }

  @override
  Widget build(BuildContext context) {
    final showSelector = widget.preset == null;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showSelector)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FoodSelectionBar(
                selected: _preset,
                onChanged: _changePreset,
              ),
            ),
          ModernOvenPanel(
            poweredOn: _poweredOn,
            preset: _preset,
            options: _options,
            onTogglePower: _togglePower,
            onOptionsChanged: _changeOptions,
          ),
        ],
      ),
    );
  }
}

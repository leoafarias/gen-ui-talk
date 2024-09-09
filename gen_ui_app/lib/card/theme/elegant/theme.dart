import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:mutable_card/theme/variants.dart';
import 'package:remix/remix.dart';

class PageElegantStyles {
  late final card = Style(
    XCardStyle.base(),
    $card.chain
      ..flex.row()
      ..flex.gap(24)
      ..container.clipBehavior.antiAlias()
      ..container.wrap.intrinsicHeight()
      ..container.wrap.sizedBox(width: 550)
      ..container.borderRadius.all(0)
      ..container.border.none()
      ..container.padding(6)
      ..container.padding.right(24),
  );

  late final image = Style(
    $box.chain
      ..width(150)
      ..color.black()
      ..decoration.image(
        image: const AssetImage('assets/img_girl.jpg'),
        fit: BoxFit.cover,
      ),
  );

  final title = Style(
    $text.chain
      ..style.as(GoogleFonts.sourceSerif4())
      ..style.fontSize(20)
      // ..style.fontWeight.bold()
      ..wrap.padding.top(16)
      ..wrap.padding.bottom(6),
  );

  final subtitle = Style(
    $text.chain
      ..style.as(GoogleFonts.inter())
      ..directive.uppercase()
      ..style.fontSize(12)
      ..style.color.blueGrey()
      ..wrap.padding.bottom(16),
  );

  final segmentControl = Style(
    $segmentedControl.chain
      ..flex.gap(8)
      ..container.color.transparent()
      ..container.padding.all(0),
    $segmentedControl.item.chain
      ..container.color.transparent()
      ..container.height(30)
      ..container.width(30)
      ..container.borderRadius(20)
      ..container.padding(0)
      ..flex.mainAxisAlignment.center()
      ..label.style.fontSize(13)
      ..label.style.fontWeight.w400()
      ..label.style.color.black54(),
    $on.selected(
      $segmentedControl.item.chain
        ..container.shadow.color.transparent()
        ..container.color.black.withOpacity(0.05)
        ..container.alignment.center()
        ..label.style.color.black(),
    ),
  );

  final button = Style(
    XButtonStyle.base(),
    $button.chain
      ..flex.mainAxisSize.max()
      ..label.style.as(
            GoogleFonts.interTight(
                fontWeight: FontWeight.w500, fontSize: 12, letterSpacing: 1.2),
          )
      ..label.directive.uppercase()
      ..container.padding.vertical(0)
      ..container.borderRadius(0)
      ..container.height(40),
    outline(
      $button.chain
        ..label.style.color.black()
        ..container.color.transparent()
        ..container.border.color.black26(),
    ),
  );
  final checkbox = Style(
    XCheckboxStyle.base(),
    $checkbox.chain
      ..indicator.wrap.clearModifiers()
      ..indicator.color.black26()
      ..container.border.color.black26()
      ..container.borderRadius.zero()
      ..container.height(40)
      ..container.width(40)
      ..container.color.transparent()
      ..container.padding(0),
  );

  final footer = Style(
    $text.chain
      ..style.as(GoogleFonts.interTight(letterSpacing: 1.2))
      ..style.fontSize(12)
      ..style.color.blueGrey()
      ..wrap.padding.vertical(16),
  );
}

import 'package:flutter/material.dart';

import 'package:mix/mix.dart';
import 'package:mutable_card/theme/variants.dart';
import 'package:remix/remix.dart';
import 'package:google_fonts/google_fonts.dart';

class PageBrutalistStyles {
  late final card = Style(
    XCardStyle.base(),
    $card.chain
      ..flex.row()
      ..flex.gap(12)
      ..container.linearGradient.begin.topCenter()
      ..container.linearGradient.end.center()
      ..container.linearGradient.stops([0.63, 0.63])
      ..container.linearGradient.colors([
        Colors.black,
        Colors.white,
      ])
      ..container.clipBehavior.antiAlias()
      ..container.wrap.intrinsicHeight()
      ..container.wrap.sizedBox(width: 540)
      ..container.borderRadius.all(0)
      ..container.border.none()
      ..container.padding(6)
      ..container.padding.right(24),
  );

  late final image = Style(
    $box.chain
      ..width(150)
      ..wrap.padding(16)
      ..shadow.color.tealAccent.shade400()
      ..shadow.offset(2, 2)
      ..shadow.blurRadius(0)
      ..color.black()
      ..decoration.image(
        image: const AssetImage('assets/img_girl.jpg'),
        fit: BoxFit.cover,
      ),
  );

  final title = Style(
    $text.chain
      ..style.as(GoogleFonts.ibmPlexMono())
      ..style.fontSize(16)
      ..style.color.white()
      ..style.fontWeight.bold()
      ..wrap.padding.top(16)
      ..wrap.padding.bottom(6),
  );

  final subtitle = Style(
    $text.chain
      ..style.as(GoogleFonts.ibmPlexMono())
      ..directive.uppercase()
      ..style.color.tealAccent.shade400()
      ..style.fontSize(12)
      ..wrap.padding.bottom(16),
  );

  final segmentControl = Style(
    $segmentedControl.chain
      ..flex.gap(8)
      ..container.color.transparent()
      ..container.padding.all(0),
    $segmentedControl.item.chain
      ..container.color.transparent()
      ..container.height(35)
      ..container.width(35)
      ..container.borderRadius(0)
      ..container.padding(0)
      ..flex.mainAxisAlignment.center()
      ..label.style.fontSize(13)
      ..label.style.as(GoogleFonts.ibmPlexMono())
      ..label.style.fontWeight.w400()
      ..label.style.color.black(),
    $on.selected(
      $segmentedControl.item.chain
        ..container.shadow.color.tealAccent.shade400()
        ..container.shadow.offset(1, 1)
        ..container.shadow.blurRadius(0)
        ..container.color.black()
        ..container.alignment.center()
        ..label.style.color.white(),
    ),
  );

  final button = Style(
    XButtonStyle.base(),
    $button.chain
      ..label.style.as(
            GoogleFonts.ibmPlexMono(
              fontWeight: FontWeight.w600,
            ),
          )
      ..label.style.color.black()
      ..label.directive.uppercase()
      ..container.border.color.black()
      ..container.border.width(2)
      ..container.color.tealAccent.shade400()
      ..container.padding.vertical(0)
      ..container.borderRadius(0)
      ..container.height(40),
    outline(
      $button.chain
        ..container.border.width(1)
        ..label.style.color.black()
        ..container.color.transparent()
        ..container.border.color.black26(),
    ),
  );

  final checkbox = Style(
    XCheckboxStyle.base(),
    $checkbox.chain
      ..indicator.wrap.clearModifiers()
      ..indicator.color.black()
      ..container.borderRadius.zero()
      ..container.height(40)
      ..container.width(35)
      ..container.color.transparent()
      ..container.border.none()
      ..container.padding(0),
  );

  final footer = Style(
    $text.chain
      ..style.as(GoogleFonts.ibmPlexMono())
      ..style.fontSize(11)
      ..style.color.blueGrey()
      ..wrap.padding.vertical(16),
  );
}

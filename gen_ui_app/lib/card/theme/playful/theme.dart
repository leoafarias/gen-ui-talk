import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mix/mix.dart';
import 'package:mutable_card/theme/variants.dart';
import 'package:remix/remix.dart';

class PagePlayfulStyles {
  late final card = Style(
    XCardStyle.base(),
    $card.chain
      ..flex.row()
      ..flex.gap(24)
      ..container.wrap.intrinsicHeight()
      ..container.wrap.sizedBox(width: 500)
      ..container.borderRadius.all(10)
      ..container.border.none()
      ..container.padding(0)
      ..container.padding.right(24),
  );

  late final image = Style(
    $box.chain
      ..borderRadius(6)
      ..wrap.scale(1.06)
      ..width(150)
      ..color.black()
      ..decoration.image(
        image: const AssetImage('assets/img_girl.jpg'),
        fit: BoxFit.cover,
      ),
  );

  final title = Style(
    $text.chain
      ..style.as(
        GoogleFonts.balooBhai2(
          fontWeight: FontWeight.w500,
        ),
      )
      ..style.fontSize(16)
      ..style.fontWeight.bold()
      ..wrap.padding.top(16)
      ..wrap.padding.bottom(6),
  );

  final subtitle = Style(
    $text.chain
      ..style.as(
        GoogleFonts.balooBhai2(
          fontWeight: FontWeight.w600,
        ),
      )
      ..style.fontSize(14)
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
      ..container.height(35)
      ..container.width(35)
      ..container.borderRadius(20)
      ..container.padding(0)
      ..flex.mainAxisAlignment.center()
      ..label.style.as(
            GoogleFonts.balooBhai2(
              fontWeight: FontWeight.w600,
            ),
          )
      ..label.style.fontSize(13)
      ..label.style.fontWeight.w700()
      ..label.style.color.deepPurpleAccent.shade100(),
    $on.selected(
      $segmentedControl.item.chain
        ..container.color.deepPurpleAccent()
        ..container.alignment.center()
        ..label.style.color.white(),
    ),
  );

  final button = Style(
    XButtonStyle.base(),
    $button.chain
      ..label.style.as(
            GoogleFonts.balooBhai2(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              fontSize: 15,
            ),
          )
      ..container.padding.vertical(0)
      ..container.shape.stadium()
      ..container.height(45)
      ..container.color.deepPurpleAccent()
      ..container.padding.horizontal(18),
    outline(
      $button.chain
        ..label.style.color.black()
        ..container.color.transparent()
        ..container.shape.stadium.side.color.black.withOpacity(0.15),
    ),
  );
  final checkbox = Style(
    XCheckboxStyle.base(),
    $checkbox.chain
      ..indicator.wrap.clearModifiers()
      ..indicator.color.deepPurpleAccent()
      ..container.color.deepPurpleAccent.withOpacity(0.1)
      ..container.border.none()
      ..container.borderRadius(30)
      ..container.height(40)
      ..container.width(40)
      ..container.padding(0),
  );

  final footer = Style(
    $text.chain
      ..style.as(
        GoogleFonts.balooBhai2(
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
      )
      ..style.color.blueGrey()
      ..wrap.padding.vertical(16),
  );
}

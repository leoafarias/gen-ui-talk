import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import '../variants.dart';

class PageSimpleStyles {
  final card = Style(
    XCardStyle.base(),
    $card.chain
      ..flex.row()
      ..flex.gap(24)
      ..container.clipBehavior.antiAlias()
      ..container.wrap.intrinsicHeight()
      ..container.wrap.sizedBox(width: 500)
      ..container.borderRadius.all(10)
      ..container.border.none()
      ..container.padding(0)
      ..container.padding.right(24),
  );

  final image = Style(
    $box.chain
      ..color.black()
      ..decoration.image(
        image: const AssetImage('assets/img_girl.jpg'),
        fit: BoxFit.cover,
      ),
    $box.width(150),
  );

  final title = Style(
    $text.chain
      ..style.fontSize(18)
      ..style.fontWeight.bold()
      ..wrap.padding.top(16)
      ..wrap.padding.bottom(6),
  );

  final subtitle = Style(
    $text.chain
      ..style.fontSize(14)
      ..style.color.black87()
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
      ..container.padding(0)
      ..flex.mainAxisAlignment.center()
      ..label.style.color.black(),
    $on.selected(
      $segmentedControl.item.chain
        ..container.color.black()
        ..container.alignment.center()
        ..label.style.color.white(),
    ),
  );

  final button = Style(
    $button.chain
      ..container.padding.vertical(0)
      ..container.height(40),
    outline(
      $button.chain
        ..label.style.color.black()
        ..container.color.transparent()
        ..container.border.color.black26(),
    ),
  );
  final checkbox = Style(
    $checkbox.chain
      ..indicator.wrap.clearModifiers()
      ..indicator.color.black26()
      ..container.border.color.black26()
      ..container.borderRadius.all(5)
      ..container.height(40)
      ..container.width(40)
      ..container.color.transparent()
      ..container.padding(0),
  );

  final footer = Style(
    $text.chain
      ..style.fontSize(14)
      ..style.color.black87()
      ..wrap.padding.vertical(16),
  );
}

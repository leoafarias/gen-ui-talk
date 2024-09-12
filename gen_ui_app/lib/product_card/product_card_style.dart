import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'product_card_spec.dart';

const outlinedButton = Variant('button:outlined');

class ProductCardStyle {
  const ProductCardStyle();

  ProductCardSpecUtility<ProductCardSpecAttribute> get $ =>
      ProductCardSpecUtility.self;

  @protected
  Style extend(Style style) => build().merge(style);

  Style build() {
    final cardStyle = [
      $.card.container.chain
        ..maxWidth(300)
        ..maxHeight(400)
        ..color.white()
        ..borderRadius(10)
        ..elevation(3),
    ];

    final buttonStyle = [
      $.button.container.chain
        ..color.black()
        ..padding.horizontal(12)
        ..padding.vertical(8)
        ..borderRadius(8),
      $.button.label.chain
        ..style.fontSize(14)
        ..style.color.white(),
    ];

    final outlinedButtonStyle = [
      ...buttonStyle,
      $.button.container.chain
        ..color.white()
        ..border.width(1)
        ..border.color.black(),
    ];

    final typographyStyle = [
      $.title.chain
        ..style.fontSize(18)
        ..style.fontWeight.bold()
        ..style.color.black()
        ..textAlign.center(),
      $.subtitle.chain
        ..style.fontSize(14)
        ..style.fontWeight.w300()
        ..style.color.black54()
        ..textAlign.center(),
    ];

    final topStyle = [
      $.topFlex.wrap.expanded(),
      $.topContainer.maxHeight(150),
    ];

    final bottomStyle = [
      $.bottomFlex.chain
        ..mainAxisAlignment.spaceBetween()
        ..wrap.flexible()
        ..gap(4),
      $.bottomContainer.chain
        ..padding.all(12)
        ..color.grey(),
    ];

    final contentStyle = [
      $.contentFlex.chain
        ..crossAxisAlignment.start()
        ..mainAxisSize.max()
        ..gap(4),
      $.contentContainer.chain
        ..padding.all(12)
        ..wrap.expanded(),
    ];

    final imageStyle = [
      $.image.chain
        ..fit.cover()
        ..wrap.expanded()
    ];

    return Style.create([
      ...cardStyle,
      ...imageStyle,
      ...topStyle,
      ...typographyStyle,
      ...contentStyle,
      ...bottomStyle,
      ...buttonStyle,
      outlinedButton(Style.create(outlinedButtonStyle)()),
    ]);
  }
}

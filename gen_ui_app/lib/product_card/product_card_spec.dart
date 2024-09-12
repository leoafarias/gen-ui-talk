import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

part 'product_card_spec.g.dart';

@MixableSpec()
class ProductCardSpec extends Spec<ProductCardSpec> with _$ProductCardSpec {
  // @MixableProperty(utilities: [MixableUtility(type: CardSpecUtility)])
  @MixableProperty(dto: MixableFieldDto(type: 'CardSpecAttribute'))
  final CardSpec card;
  final ImageSpec image;
  final TextSpec title;
  final TextSpec subtitle;
  final TextSpec description;
  final TextSpec price;
  final FlexSpec bottomFlex;
  final BoxSpec bottomContainer;
  final BoxSpec topContainer;
  final FlexSpec topFlex;
  final BoxSpec contentContainer;
  final FlexSpec contentFlex;

  // @MixableProperty(utilities: [MixableUtility(type: ButtonSpecUtility)])
  @MixableProperty(dto: MixableFieldDto(type: 'ButtonSpecAttribute'))
  final ButtonSpec button;

  static const of = _$ProductCardSpec.of;
  static const from = _$ProductCardSpec.from;

  const ProductCardSpec({
    CardSpec? card,
    ImageSpec? image,
    TextSpec? title,
    TextSpec? subtitle,
    TextSpec? description,
    TextSpec? price,
    ButtonSpec? button,
    BoxSpec? bottomContainer,
    FlexSpec? bottomFlex,
    BoxSpec? topContainer,
    FlexSpec? topFlex,
    BoxSpec? contentContainer,
    FlexSpec? contentFlex,
  })  : card = card ?? const CardSpec(),
        image = image ?? const ImageSpec(),
        title = title ?? const TextSpec(),
        subtitle = subtitle ?? const TextSpec(),
        description = description ?? const TextSpec(),
        price = price ?? const TextSpec(),
        button = button ?? const ButtonSpec(),
        bottomFlex = bottomFlex ?? const FlexSpec(),
        bottomContainer = bottomContainer ?? const BoxSpec(),
        topContainer = topContainer ?? const BoxSpec(),
        topFlex = topFlex ?? const FlexSpec(),
        contentContainer = contentContainer ?? const BoxSpec(),
        contentFlex = contentFlex ?? const FlexSpec();
}

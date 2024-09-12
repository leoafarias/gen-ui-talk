// ignore_for_file: non_constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mix/mix.dart';

import 'product_card_spec.dart';
import 'product_card_style.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.description,
    required this.price,
    required this.buttonLabel,
    this.style = const Style.empty(),
    this.variant,
    this.onPressed,
    required this.image,
  });

  final VoidCallback? onPressed;
  final Style style;
  final Variant? variant;
  final ImageProvider<Object> image;
  final String title;
  final String? subtitle;
  final String description;
  final double price;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return SpecBuilder(
        style: const ProductCardStyle().build(),
        builder: (context) {
          final spec = ProductCardSpec.of(context);

          return spec.card(
            children: [
              spec.topContainer(
                child: spec.topFlex(
                  direction: Axis.horizontal,
                  children: [
                    spec.image(image: image),
                  ],
                ),
              ),
              spec.contentContainer(
                child: spec.contentFlex(
                  direction: Axis.vertical,
                  children: [
                    spec.title(title),
                    if (subtitle != null) spec.subtitle(subtitle!),
                    spec.description(description),
                  ],
                ),
              ),
              spec.bottomContainer(
                child: spec.bottomFlex(
                  direction: Axis.horizontal,
                  children: [
                    spec.price(
                      NumberFormat.currency(locale: 'en_US', symbol: r'$')
                          .format(price),
                    ),
                    spec.button(
                      label: buttonLabel,
                      onPressed: onPressed ?? () {},
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

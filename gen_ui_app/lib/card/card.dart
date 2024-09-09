import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

import './card.styles.dart';
import './theme/variants.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key, required this.variant, required this.styles});

  final Variant variant;
  final PageStyles styles;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: XCard(
        style: styles.card,
        variants: [variant],
        children: [
          Box(
            inherit: true,
            style: styles.image.applyVariant(variant),
          ),
          VBox(
            style: Style(
              $with.expanded(),
              $flex.crossAxisAlignment.start(),
            ),
            children: [
              StyledText(
                'Classic Utility Jacket',
                style: styles.title.applyVariant(variant),
              ),
              StyledText(
                'In Stock',
                style: styles.subtitle.applyVariant(variant),
              ),
              XSegmentedControl(
                buttons: const [
                  XSegmentButton(text: 'XL'),
                  XSegmentButton(text: 'LG'),
                  XSegmentButton(text: 'MD'),
                  XSegmentButton(text: 'SM'),
                ],
                style: styles.segmentControl,
                variants: [variant],
                onIndexChanged: (_) {},
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(
                  height: 6,
                ),
              ),
              StyledFlex(
                direction: Axis.horizontal,
                style: Style(
                  $flex.gap(16),
                ),
                children: [
                  XButton(
                    label: 'Buy now',
                    onPressed: () {},
                    variants: [variant],
                    style: styles.button,
                  ),
                  XButton(
                    label: 'Add to bag',
                    onPressed: () {},
                    variants: [outline, variant],
                    style: styles.button,
                  ),
                  const Spacer(),
                  XCheckbox(
                    value: false,
                    onChanged: (_) {},
                    variants: [variant],
                    iconChecked: CupertinoIcons.heart_fill,
                    style: styles.checkbox,
                  ),
                ],
              ),
              StyledText(
                'Free shipping on all continental US orders',
                style: styles.footer.applyVariant(variant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

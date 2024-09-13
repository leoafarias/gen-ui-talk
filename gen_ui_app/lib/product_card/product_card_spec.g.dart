// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_card_spec.dart';

// **************************************************************************
// MixableSpecGenerator
// **************************************************************************

mixin _$ProductCardSpec on Spec<ProductCardSpec> {
  static ProductCardSpec from(MixData mix) {
    return mix.attributeOf<ProductCardSpecAttribute>()?.resolve(mix) ??
        const ProductCardSpec();
  }

  /// {@template product_card_spec_of}
  /// Retrieves the [ProductCardSpec] from the nearest [Mix] ancestor in the widget tree.
  ///
  /// This method uses [Mix.of] to obtain the [Mix] instance associated with the
  /// given [BuildContext], and then retrieves the [ProductCardSpec] from that [Mix].
  /// If no ancestor [Mix] is found, this method returns an empty [ProductCardSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final productCardSpec = ProductCardSpec.of(context);
  /// ```
  /// {@endtemplate}
  static ProductCardSpec of(BuildContext context) {
    return _$ProductCardSpec.from(Mix.of(context));
  }

  /// Creates a copy of this [ProductCardSpec] but with the given fields
  /// replaced with the new values.
  @override
  ProductCardSpec copyWith({
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
  }) {
    return ProductCardSpec(
      card: card ?? _$this.card,
      image: image ?? _$this.image,
      title: title ?? _$this.title,
      subtitle: subtitle ?? _$this.subtitle,
      description: description ?? _$this.description,
      price: price ?? _$this.price,
      button: button ?? _$this.button,
      bottomContainer: bottomContainer ?? _$this.bottomContainer,
      bottomFlex: bottomFlex ?? _$this.bottomFlex,
      topContainer: topContainer ?? _$this.topContainer,
      topFlex: topFlex ?? _$this.topFlex,
      contentContainer: contentContainer ?? _$this.contentContainer,
      contentFlex: contentFlex ?? _$this.contentFlex,
    );
  }

  /// Linearly interpolates between this [ProductCardSpec] and another [ProductCardSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [ProductCardSpec] is returned. When [t] is 1.0, the [other] [ProductCardSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [ProductCardSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [ProductCardSpec] instance.
  ///
  /// The interpolation is performed on each property of the [ProductCardSpec] using the appropriate
  /// interpolation method:
  ///
  /// - [CardSpec.lerp] for [card].
  /// - [ImageSpec.lerp] for [image].
  /// - [TextSpec.lerp] for [title] and [subtitle] and [description] and [price].
  /// - [ButtonSpec.lerp] for [button].
  /// - [BoxSpec.lerp] for [bottomContainer] and [topContainer] and [contentContainer].
  /// - [FlexSpec.lerp] for [bottomFlex] and [topFlex] and [contentFlex].

  /// For , the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [ProductCardSpec] is used. Otherwise, the value
  /// from the [other] [ProductCardSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [ProductCardSpec] configurations.
  @override
  ProductCardSpec lerp(ProductCardSpec? other, double t) {
    if (other == null) return _$this;

    return ProductCardSpec(
      card: _$this.card.lerp(other.card, t),
      image: _$this.image.lerp(other.image, t),
      title: _$this.title.lerp(other.title, t),
      subtitle: _$this.subtitle.lerp(other.subtitle, t),
      description: _$this.description.lerp(other.description, t),
      price: _$this.price.lerp(other.price, t),
      button: _$this.button.lerp(other.button, t),
      bottomContainer: _$this.bottomContainer.lerp(other.bottomContainer, t),
      bottomFlex: _$this.bottomFlex.lerp(other.bottomFlex, t),
      topContainer: _$this.topContainer.lerp(other.topContainer, t),
      topFlex: _$this.topFlex.lerp(other.topFlex, t),
      contentContainer: _$this.contentContainer.lerp(other.contentContainer, t),
      contentFlex: _$this.contentFlex.lerp(other.contentFlex, t),
    );
  }

  /// The list of properties that constitute the state of this [ProductCardSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ProductCardSpec] instances for equality.
  @override
  List<Object?> get props => [
        _$this.card,
        _$this.image,
        _$this.title,
        _$this.subtitle,
        _$this.description,
        _$this.price,
        _$this.button,
        _$this.bottomContainer,
        _$this.bottomFlex,
        _$this.topContainer,
        _$this.topFlex,
        _$this.contentContainer,
        _$this.contentFlex,
      ];

  ProductCardSpec get _$this => this as ProductCardSpec;
}

/// Represents the attributes of a [ProductCardSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [ProductCardSpec].
///
/// Use this class to configure the attributes of a [ProductCardSpec] and pass it to
/// the [ProductCardSpec] constructor.
class ProductCardSpecAttribute extends SpecAttribute<ProductCardSpec> {
  final CardSpecAttribute? card;
  final ImageSpecAttribute? image;
  final TextSpecAttribute? title;
  final TextSpecAttribute? subtitle;
  final TextSpecAttribute? description;
  final TextSpecAttribute? price;
  final ButtonSpecAttribute? button;
  final BoxSpecAttribute? bottomContainer;
  final FlexSpecAttribute? bottomFlex;
  final BoxSpecAttribute? topContainer;
  final FlexSpecAttribute? topFlex;
  final BoxSpecAttribute? contentContainer;
  final FlexSpecAttribute? contentFlex;

  const ProductCardSpecAttribute({
    this.card,
    this.image,
    this.title,
    this.subtitle,
    this.description,
    this.price,
    this.button,
    this.bottomContainer,
    this.bottomFlex,
    this.topContainer,
    this.topFlex,
    this.contentContainer,
    this.contentFlex,
  });

  /// Resolves to [ProductCardSpec] using the provided [MixData].
  ///
  /// If a property is null in the [MixData], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final productCardSpec = ProductCardSpecAttribute(...).resolve(mix);
  /// ```
  @override
  ProductCardSpec resolve(MixData mix) {
    return ProductCardSpec(
      card: card?.resolve(mix),
      image: image?.resolve(mix),
      title: title?.resolve(mix),
      subtitle: subtitle?.resolve(mix),
      description: description?.resolve(mix),
      price: price?.resolve(mix),
      button: button?.resolve(mix),
      bottomContainer: bottomContainer?.resolve(mix),
      bottomFlex: bottomFlex?.resolve(mix),
      topContainer: topContainer?.resolve(mix),
      topFlex: topFlex?.resolve(mix),
      contentContainer: contentContainer?.resolve(mix),
      contentFlex: contentFlex?.resolve(mix),
    );
  }

  /// Merges the properties of this [ProductCardSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [ProductCardSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  ProductCardSpecAttribute merge(covariant ProductCardSpecAttribute? other) {
    if (other == null) return this;

    return ProductCardSpecAttribute(
      card: card?.merge(other.card) ?? other.card,
      image: image?.merge(other.image) ?? other.image,
      title: title?.merge(other.title) ?? other.title,
      subtitle: subtitle?.merge(other.subtitle) ?? other.subtitle,
      description: description?.merge(other.description) ?? other.description,
      price: price?.merge(other.price) ?? other.price,
      button: button?.merge(other.button) ?? other.button,
      bottomContainer: bottomContainer?.merge(other.bottomContainer) ??
          other.bottomContainer,
      bottomFlex: bottomFlex?.merge(other.bottomFlex) ?? other.bottomFlex,
      topContainer:
          topContainer?.merge(other.topContainer) ?? other.topContainer,
      topFlex: topFlex?.merge(other.topFlex) ?? other.topFlex,
      contentContainer: contentContainer?.merge(other.contentContainer) ??
          other.contentContainer,
      contentFlex: contentFlex?.merge(other.contentFlex) ?? other.contentFlex,
    );
  }

  /// The list of properties that constitute the state of this [ProductCardSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [ProductCardSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [
        card,
        image,
        title,
        subtitle,
        description,
        price,
        button,
        bottomContainer,
        bottomFlex,
        topContainer,
        topFlex,
        contentContainer,
        contentFlex,
      ];
}

/// Utility class for configuring [ProductCardSpec] properties.
///
/// This class provides methods to set individual properties of a [ProductCardSpec].
/// Use the methods of this class to configure specific properties of a [ProductCardSpec].
class ProductCardSpecUtility<T extends Attribute>
    extends SpecUtility<T, ProductCardSpecAttribute> {
  /// Utility for defining [ProductCardSpecAttribute.card]
  late final card = CardSpecUtility((v) => only(card: v));

  /// Utility for defining [ProductCardSpecAttribute.image]
  late final image = ImageSpecUtility((v) => only(image: v));

  /// Utility for defining [ProductCardSpecAttribute.title]
  late final title = TextSpecUtility((v) => only(title: v));

  /// Utility for defining [ProductCardSpecAttribute.subtitle]
  late final subtitle = TextSpecUtility((v) => only(subtitle: v));

  /// Utility for defining [ProductCardSpecAttribute.description]
  late final description = TextSpecUtility((v) => only(description: v));

  /// Utility for defining [ProductCardSpecAttribute.price]
  late final price = TextSpecUtility((v) => only(price: v));

  /// Utility for defining [ProductCardSpecAttribute.button]
  late final button = ButtonSpecUtility((v) => only(button: v));

  /// Utility for defining [ProductCardSpecAttribute.bottomContainer]
  late final bottomContainer = BoxSpecUtility((v) => only(bottomContainer: v));

  /// Utility for defining [ProductCardSpecAttribute.bottomFlex]
  late final bottomFlex = FlexSpecUtility((v) => only(bottomFlex: v));

  /// Utility for defining [ProductCardSpecAttribute.topContainer]
  late final topContainer = BoxSpecUtility((v) => only(topContainer: v));

  /// Utility for defining [ProductCardSpecAttribute.topFlex]
  late final topFlex = FlexSpecUtility((v) => only(topFlex: v));

  /// Utility for defining [ProductCardSpecAttribute.contentContainer]
  late final contentContainer =
      BoxSpecUtility((v) => only(contentContainer: v));

  /// Utility for defining [ProductCardSpecAttribute.contentFlex]
  late final contentFlex = FlexSpecUtility((v) => only(contentFlex: v));

  ProductCardSpecUtility(super.builder, {super.mutable});

  ProductCardSpecUtility<T> get chain =>
      ProductCardSpecUtility(attributeBuilder, mutable: true);

  static ProductCardSpecUtility<ProductCardSpecAttribute> get self =>
      ProductCardSpecUtility((v) => v);

  /// Returns a new [ProductCardSpecAttribute] with the specified properties.
  @override
  T only({
    CardSpecAttribute? card,
    ImageSpecAttribute? image,
    TextSpecAttribute? title,
    TextSpecAttribute? subtitle,
    TextSpecAttribute? description,
    TextSpecAttribute? price,
    ButtonSpecAttribute? button,
    BoxSpecAttribute? bottomContainer,
    FlexSpecAttribute? bottomFlex,
    BoxSpecAttribute? topContainer,
    FlexSpecAttribute? topFlex,
    BoxSpecAttribute? contentContainer,
    FlexSpecAttribute? contentFlex,
  }) {
    return builder(ProductCardSpecAttribute(
      card: card,
      image: image,
      title: title,
      subtitle: subtitle,
      description: description,
      price: price,
      button: button,
      bottomContainer: bottomContainer,
      bottomFlex: bottomFlex,
      topContainer: topContainer,
      topFlex: topFlex,
      contentContainer: contentContainer,
      contentFlex: contentFlex,
    ));
  }
}

/// A tween that interpolates between two [ProductCardSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [ProductCardSpec] specifications.
class ProductCardSpecTween extends Tween<ProductCardSpec?> {
  ProductCardSpecTween({
    super.begin,
    super.end,
  });

  @override
  ProductCardSpec lerp(double t) {
    if (begin == null && end == null) {
      return const ProductCardSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}

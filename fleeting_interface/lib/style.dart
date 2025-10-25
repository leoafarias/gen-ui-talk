import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:superdeck/superdeck.dart';

SlideStyle coverStyle() {
  return SlideStyle(
    h1: TextStyler().style(
      TextStyleMix(
        fontFamily: GoogleFonts.bungeeShade().fontFamily,
        fontSize: 100,
        color: Colors.black,
      ),
    ),
    slideContainer: BoxStyler(
      decoration: BoxDecorationMix(
        gradient: LinearGradientMix(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.6, 0.9, 1.0],
          colors: [
            const Color.fromARGB(255, 255, 255, 255),
            const Color.fromARGB(255, 222, 222, 222),
            const Color.fromARGB(255, 53, 126, 253),
            const Color.fromARGB(255, 25, 74, 233),
          ],
        ),
      ),
    ),
  );
}

SlideStyle announcementStyle() {
  return SlideStyle(
    h1: TextStyler().style(
      TextStyleMix(
        fontSize: 140,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 201, 195, 139),
        height: 0.6,
      ),
    ),
    h2: TextStyler().style(TextStyleMix(fontSize: 140, height: 0.6)),
    h3: TextStyler().style(
      TextStyleMix(
        fontSize: 60,
        color: Colors.white,
        fontWeight: FontWeight.w100,
      ),
    ),
    blockContainer: BoxStyler(
      decoration: BoxDecorationMix(
        gradient: LinearGradientMix(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.5),
            Colors.black.withValues(alpha: 0.95),
          ],
        ),
      ),
    ),
  );
}

SlideStyle quoteStyle() {
  return SlideStyle(
    h1: TextStyler().style(
      TextStyleMix(
        fontFamily: GoogleFonts.notoSerif().fontFamily,
        fontSize: 42,
        height: 1.4,
      ),
    ),
    blockquote: MarkdownBlockquoteStyle(
      textStyle: GoogleFonts.notoSerif(fontSize: 32),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Colors.red, width: 4)),
      ),
    ),
    p: TextStyler().style(TextStyleMix(fontSize: 32)),
    h6: TextStyler().style(
      TextStyleMix(
        fontFamily: GoogleFonts.notoSerif().fontFamily,
        fontSize: 20,
      ),
    ),
  );
}

SlideStyle borderedStyle() {
  return SlideStyle(
    slideContainer: BoxStyler(
      // No margin/padding - border goes to viewport edges
      decoration: BoxDecorationMix(
        border: BoxBorderMix.all(
          BorderSideMix(
            color: Colors.white,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        borderRadius: BorderRadiusMix.all(Radius.circular(16)),
      ),
    ),
  );
}

SlideStyle fullscreenStyle() {
  return SlideStyle(slideContainer: BoxStyler().paddingY(0));
}

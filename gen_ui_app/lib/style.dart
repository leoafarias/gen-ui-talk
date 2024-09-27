import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mix/mix.dart';
import 'package:superdeck/superdeck.dart';

const _accent = Color(0xff73F8FB);

class BaseStyle extends DeckStyle {
  BaseStyle();

  @override
  Style build() {
    return super.build().merge(
          Style(
              // $.baseTextStyle.as(GoogleFonts.poppins()),
              // $.contentContainer.padding.right(24),
              // $.h1.chain
              //   ..style.height(0.8)
              //   ..style.fontWeight.w900()
              //   ..style.fontSize(100),
              // $.h2.chain
              //   ..style.height(0.8)
              //   ..style.height(1.2)
              //   ..style.fontWeight.w100()
              //   ..style.fontSize(80),
              // $.h3.chain
              //   ..style.fontSize(36)
              //   ..style.height(1.2),
              // $.alert.all.chain
              //   ..heading.style.fontSize(24)
              //   ..icon.size(24)
              //   ..description.style.fontSize(24)
              //   ..description.style.fontWeight.w400(),
              // $.p.style.as(GoogleFonts.jetBrainsMono()),
              // $.p.style.fontSize(28),
              // $.p.style.color.tealAccent(),
              // $.alert.note.chain
              //   ..heading.style.color(_accent)
              //   ..icon.color(_accent)
              //   ..container.border.left.color(_accent),
              // $.code.chain
              //   ..textStyle.as(GoogleFonts.jetBrainsMono())
              //   ..decoration.color(
              //     const Color.fromARGB(255, 3, 17, 19),
              //   )
              //   ..decoration.border.all(
              //         color: const Color.fromARGB(255, 38, 168, 170),
              //         width: 1,
              //       ),
              ),
        );
  }
}

class DemoStyle extends DeckStyle {
  DemoStyle();
  @override
  Style build() {
    return Style($.slideContainer.padding(0));
  }
}

class CoverStyle extends DeckStyle {
  CoverStyle();

  @override
  Style build() {
    return super.build().merge(
          Style(
            $.h1.style.height(0.8),
            $.h2.style.height(0.8),
            $.h3.style.height(1),
          ),
        );
  }
}

class AnnouncementStyle extends DeckStyle {
  AnnouncementStyle();
  @override
  Style build() {
    return super.build().merge(
          Style(
            $.baseTextStyle.height(0.6),
            $.h1.chain
              ..style.fontSize(140)
              ..style.bold()
              ..style.color(const Color.fromARGB(255, 201, 195, 139)),
            $.h2.style.fontSize(140),
            $.h3.chain
              ..style.fontSize(60)
              ..style.color(Colors.white)
              ..style.fontWeight(FontWeight.w100),
            $.contentContainer.gradient.linear(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.95),
              ],
            ),
          ),
        );
  }
}

class QuoteStyle extends DeckStyle {
  QuoteStyle();
  @override
  Style build() {
    return super.build().merge(
          Style(
            $.blockquote.chain
              ..textStyle.as(GoogleFonts.notoSerif())
              ..decoration.border.left(
                    width: 4,
                    color: Colors.red,
                  ),
            $.p.style.fontSize(32),
            $.h6.chain
              ..style.as(GoogleFonts.notoSerif())
              ..style.fontSize(20),
          ),
        );
  }
}

class ShowSectionsStyle extends DeckStyle {
  ShowSectionsStyle();
  @override
  Style build() {
    return super.build().merge(
          Style(
            $.slideContainer.chain
              ..borderRadius(10)
              ..border.all(
                color: Colors.blue,
                width: 2,
              ),
          ),
        );
  }
}

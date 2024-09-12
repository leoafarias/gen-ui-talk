// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mix/mix.dart';
// import 'package:remix/remix.dart';

// import '../card_spec.dart';

// final brutalistCardTheme = baseCardTheme.extend(
//   card: Style(
//     $card.flex.gap(12),
//     $card.container.chain
//       ..linearGradient.begin.topCenter()
//       ..linearGradient.end.center()
//       ..linearGradient.stops([0.63, 0.63])
//       ..linearGradient.colors([
//         Colors.black,
//         Colors.white,
//       ])
//       ..wrap.sizedBox(width: 540)
//       ..borderRadius.all(0)
//       ..padding(6),
//   ),
//   image: Style(
//     $box.chain
//       ..wrap.padding(16)
//       ..shadow.color.tealAccent.shade400()
//       ..shadow.offset(2, 2)
//       ..shadow.blurRadius(0),
//   ),
//   title: Style(
//     $text.chain
//       ..style.as(GoogleFonts.ibmPlexMono())
//       ..style.fontSize(16)
//       ..style.color.white(),
//   ),
//   subtitle: Style(
//     $text.chain
//       ..style.as(GoogleFonts.ibmPlexMono())
//       ..uppercase()
//       ..style.color.tealAccent.shade400()
//       ..style.fontSize(12),
//   ),
//   button: Style(
//     $button.chain
//       ..label.style.as(
//             GoogleFonts.ibmPlexMono(
//               fontWeight: FontWeight.w600,
//             ),
//           )
//       ..label.style.color.black()
//       ..label.directive.uppercase()
//       ..container.border.color.black()
//       ..container.border.width(2)
//       ..container.color.tealAccent.shade400()
//       ..container.borderRadius(0),
//   ),
//   checkbox: Style(
//     $checkbox.chain
//       ..indicator.color.black()
//       ..container.borderRadius.zero()
//       ..container.width(35)
//       ..container.border.none(),
//   ),
//   footer: Style(
//     $text.chain
//       ..style.as(GoogleFonts.ibmPlexMono())
//       ..style.fontSize(11),
//   ),
// );

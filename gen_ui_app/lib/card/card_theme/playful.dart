// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mix/mix.dart';
// import 'package:remix/remix.dart';

// import '../card_spec.dart';

// final playfulCardTheme = baseCardTheme.extend(
//   image: Style(
//     $box.chain
//       ..borderRadius(6)
//       ..wrap.scale(1.06),
//   ),
//   title: Style(
//     $text.chain
//       ..style.as(
//         GoogleFonts.balooBhai2(
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//   ),
//   subtitle: Style(
//     $text.chain
//       ..style.as(
//         GoogleFonts.balooBhai2(
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//   ),
//   segmentedControl: Style(
//     $segmentedControl.item.chain
//       ..container.borderRadius(20)
//       ..label.style.as(
//             GoogleFonts.balooBhai2(
//               fontWeight: FontWeight.w600,
//             ),
//           )
//       ..label.style.fontSize(13)
//       ..label.style.fontWeight.w700()
//       ..label.style.color.deepPurpleAccent.shade100(),
//     $on.selected(
//       $segmentedControl.item.chain
//         ..container.color.deepPurpleAccent()
//         ..container.alignment.center()
//         ..label.style.color.white(),
//     ),
//   ),
//   button: Style(
//     $button.chain
//       ..label.style.as(
//             GoogleFonts.balooBhai2(
//               fontWeight: FontWeight.w600,
//               letterSpacing: -0.5,
//               fontSize: 15,
//             ),
//           )
//       ..container.shape.stadium()
//       ..container.color.deepPurpleAccent()
//       ..container.padding.horizontal(18),
//     outline(
//       $button.chain
//         ..label.style.color.black()
//         ..container.color.transparent()
//         ..container.shape.stadium.side.color.black.withOpacity(0.15),
//     ),
//   ),
//   checkbox: Style(
//     $checkbox.chain
//       ..indicator.color.deepPurpleAccent()
//       ..container.color.deepPurpleAccent.withOpacity(0.1)
//       ..container.border.none()
//       ..container.borderRadius(30),
//   ),
//   footer: Style(
//     $text.chain
//       ..style.as(
//         GoogleFonts.balooBhai2(
//           fontWeight: FontWeight.w400,
//           fontSize: 13,
//         ),
//       ),
//   ),
// );

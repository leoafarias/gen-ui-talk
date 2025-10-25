// Copyright 2025 The Flutter Authors.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_genui/flutter_genui.dart';
import 'catalog/toolbar_buttons_catalog.dart';

/// Catalog of atomic toolbar widgets
/// Each button/control is a separate widget for true ephemeral composition
final adaptiveToolbarCatalog = CoreCatalogItems.asCatalog()
    .copyWithout([
      // Remove widgets we don't need for this demo
      CoreCatalogItems.audioPlayer,
      CoreCatalogItems.card,
      CoreCatalogItems.checkBox,
      CoreCatalogItems.dateTimeInput,
      CoreCatalogItems.heading,
      CoreCatalogItems.list,
      CoreCatalogItems.modal,
      CoreCatalogItems.multipleChoice,
      CoreCatalogItems.slider,
      CoreCatalogItems.tabs,
      CoreCatalogItems.video,
    ])
    .copyWith([
      // Simple Action Buttons (22)
      btnSearch,
      btnPrint,
      btnUndo,
      btnRedo,
      btnBold,
      btnItalic,
      btnUnderline,
      btnTextColor,
      btnHighlight,
      btnLink,
      btnImage,
      btnAlignLeft,
      btnAlignCenter,
      btnAlignRight,
      btnBulletList,
      btnNumberList,
      btnCheckList,
      btnIndentDecrease,
      btnIndentIncrease,
      btnClearFormatting,
      btnHistory,
      btnEdit,

      // Complex Controls (5)
      controlZoom,
      controlStyle,
      controlFontFamily,
      controlFontSize,
      controlLineSpacing,

      // Layout (1)
      dividerVertical,
    ]);

import 'package:flutter/painting.dart';

/// Raw palette (primitives) sourced 1:1 from the official DGA
/// `Primitives.Values.tokens.json` → `Colors` export. These are the atoms —
/// they never change between light and dark modes. Semantic tokens in
/// [DgaSemanticColors] reference them.
///
/// Names mirror the official token names verbatim so the mapping back to the
/// Figma source stays traceable. Never put a semantic name on this class —
/// semantic goes on [DgaSemanticColors].
abstract final class DgaPrimitives {
  const DgaPrimitives._();

  // ── Base ──────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF161616);

  // ── Primary-SA-Flag (brand green) ──────────────────────────────────────
  static const Color saFlag25 = Color(0xFFF7FDF9);
  static const Color saFlag50 = Color(0xFFF3FCF6);
  static const Color saFlag100 = Color(0xFFDFF6E7);
  static const Color saFlag200 = Color(0xFFB8EACB);
  static const Color saFlag300 = Color(0xFF88D8AD);
  static const Color saFlag400 = Color(0xFF54C08A);
  static const Color saFlag500 = Color(0xFF25935F);
  static const Color saFlag600Primary = Color(0xFF1B8354);
  static const Color saFlag700 = Color(0xFF166A45);
  static const Color saFlag800 = Color(0xFF14573A);
  static const Color saFlag900 = Color(0xFF104631);
  static const Color saFlag950 = Color(0xFF092A1E);

  // ── Secondary-Gold ────────────────────────────────────────────────────
  static const Color gold25 = Color(0xFFFFFEF7);
  static const Color gold50 = Color(0xFFFFFEF2);
  static const Color gold100 = Color(0xFFFFFCE6);
  static const Color gold200 = Color(0xFFFCF3BD);
  static const Color gold300 = Color(0xFFFAE996);
  static const Color gold400 = Color(0xFFF7D54D);
  static const Color gold500 = Color(0xFFF5BD02);
  static const Color gold600Primary = Color(0xFFDBA102);
  static const Color gold700 = Color(0xFFB87B02);
  static const Color gold800 = Color(0xFF945C01);
  static const Color gold900 = Color(0xFF6E3C00);
  static const Color gold950 = Color(0xFF472400);

  // ── Tertiary-Lavendar ─────────────────────────────────────────────────
  static const Color lavendar25 = Color(0xFFFEFCFF);
  static const Color lavendar50 = Color(0xFFF9F5FA);
  static const Color lavendar100 = Color(0xFFF2E9F5);
  static const Color lavendar200 = Color(0xFFE1CCE8);
  static const Color lavendar300 = Color(0xFFCCADD9);
  static const Color lavendar400 = Color(0xFFA57BBA);
  static const Color lavendar500Primary = Color(0xFF80519F);
  static const Color lavendar600 = Color(0xFF6D428F);
  static const Color lavendar700 = Color(0xFF532D75);
  static const Color lavendar800 = Color(0xFF3D1D5E);
  static const Color lavendar900 = Color(0xFF281047);
  static const Color lavendar950 = Color(0xFF16072E);

  // ── Neutral ───────────────────────────────────────────────────────────
  static const Color neutral25 = Color(0xFFFCFCFD);
  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral300 = Color(0xFFD2D6DB);
  static const Color neutral400 = Color(0xFF9DA4AE);
  static const Color neutral500 = Color(0xFF6C737F);
  static const Color neutral600 = Color(0xFF4D5761);
  static const Color neutral700 = Color(0xFF384250);
  static const Color neutral800 = Color(0xFF1F2A37);
  static const Color neutral900 = Color(0xFF111927);
  static const Color neutral950 = Color(0xFF0D121C);

  // ── Green ─────────────────────────────────────────────────────────────
  static const Color green25 = Color(0xFFF6FEF9);
  static const Color green50 = Color(0xFFECFDF3);
  static const Color green100 = Color(0xFFDCFAE6);
  static const Color green200 = Color(0xFFABEFC6);
  static const Color green300 = Color(0xFF75E0A7);
  static const Color green400 = Color(0xFF47CD89);
  static const Color green500 = Color(0xFF17B26A);
  static const Color green600 = Color(0xFF079455);
  static const Color green700 = Color(0xFF067647);
  static const Color green800 = Color(0xFF085D3A);
  static const Color green900 = Color(0xFF074D31);
  static const Color green950 = Color(0xFF053321);

  // ── Blue ──────────────────────────────────────────────────────────────
  static const Color blue25 = Color(0xFFF5FAFF);
  static const Color blue50 = Color(0xFFEFF8FF);
  static const Color blue100 = Color(0xFFD1E9FF);
  static const Color blue200 = Color(0xFFB2DDFF);
  static const Color blue300 = Color(0xFF84CAFF);
  static const Color blue400 = Color(0xFF53B1FD);
  static const Color blue500 = Color(0xFF2E90FA);
  static const Color blue600 = Color(0xFF1570EF);
  static const Color blue700 = Color(0xFF175CD3);
  static const Color blue800 = Color(0xFF1849A9);
  static const Color blue900 = Color(0xFF194185);
  static const Color blue950 = Color(0xFF102A56);

  // ── Yellow ────────────────────────────────────────────────────────────
  static const Color yellow25 = Color(0xFFFFFCF5);
  static const Color yellow50 = Color(0xFFFFFAEB);
  static const Color yellow100 = Color(0xFFFEF0C7);
  static const Color yellow200 = Color(0xFFFEDF89);
  static const Color yellow300 = Color(0xFFFEC84B);
  static const Color yellow400 = Color(0xFFFDB022);
  static const Color yellow500 = Color(0xFFF79009);
  static const Color yellow600 = Color(0xFFDC6803);
  static const Color yellow700 = Color(0xFFB54708);
  static const Color yellow800 = Color(0xFF93370D);
  static const Color yellow900 = Color(0xFF7A2E0E);
  static const Color yellow950 = Color(0xFF4E1D09);

  // ── Red ───────────────────────────────────────────────────────────────
  static const Color red25 = Color(0xFFFFFBFA);
  static const Color red50 = Color(0xFFFEF3F2);
  static const Color red100 = Color(0xFFFEE4E2);
  static const Color red200 = Color(0xFFFECDCA);
  static const Color red300 = Color(0xFFFDA29B);
  static const Color red400 = Color(0xFFF97066);
  static const Color red500 = Color(0xFFF04438);
  static const Color red600 = Color(0xFFD92D20);
  static const Color red700 = Color(0xFFB42318);
  static const Color red800 = Color(0xFF912018);
  static const Color red900 = Color(0xFF7A271A);
  static const Color red950 = Color(0xFF55160C);

  // ── Alpha ─────────────────────────────────────────────────────────────
  static const Color alphaWhite0 = Color(0x00FFFFFF);
  static const Color alphaWhite10 = Color(0x1AFFFFFF);
  static const Color alphaWhite20 = Color(0x33FFFFFF);
  static const Color alphaWhite30 = Color(0x4DFFFFFF);
  static const Color alphaWhite40 = Color(0x66FFFFFF);
  static const Color alphaWhite50 = Color(0x80FFFFFF);
  static const Color alphaWhite60 = Color(0x99FFFFFF);
  static const Color alphaWhite70 = Color(0xB2FFFFFF);
  static const Color alphaWhite80 = Color(0xCCFFFFFF);
  static const Color alphaWhite90 = Color(0xE6FFFFFF);
  static const Color alphaWhite100 = Color(0xFFFFFFFF);

  static const Color alphaBlack0 = Color(0x00161616);
  static const Color alphaBlack10 = Color(0x1A161616);
  static const Color alphaBlack20 = Color(0x33161616);
  static const Color alphaBlack30 = Color(0x4D161616);
  static const Color alphaBlack40 = Color(0x66161616);
  static const Color alphaBlack50 = Color(0x80161616);
  static const Color alphaBlack60 = Color(0x99161616);
  static const Color alphaBlack70 = Color(0xB2161616);
  static const Color alphaBlack80 = Color(0xCC161616);
  static const Color alphaBlack90 = Color(0xE6161616);
  static const Color alphaBlack100 = Color(0xFF161616);

  static const Color alpha600Primary10 = Color(0x1A1B8354);
  static const Color alpha600Primary20 = Color(0x331B8354);
  static const Color alpha600Primary30 = Color(0x4D1B8354);
  static const Color alpha600Primary40 = Color(0x661B8354);
  static const Color alpha600Primary50 = Color(0x801B8354);
  static const Color alpha600Primary60 = Color(0x991B8354);
  static const Color alpha600Primary70 = Color(0xB21B8354);
  static const Color alpha600Primary80 = Color(0xCC1B8354);
  static const Color alpha600Primary90 = Color(0xE61B8354);
  static const Color alpha600Primary100 = Color(0xFF1B8354);

  static const Color alphaYellow10 = Color(0x1ADC6803);
  static const Color alphaYellow20 = Color(0x33DC6803);
  static const Color alphaRed10 = Color(0x1AD92D20);
  static const Color alphaRed20 = Color(0x33D92D20);
  static const Color alphaBlue10 = Color(0x1A1570EF);
  static const Color alphaBlue20 = Color(0x331570EF);
  static const Color alphaGreen10 = Color(0x1A079455);
  static const Color alphaGreen20 = Color(0x33079455);
}

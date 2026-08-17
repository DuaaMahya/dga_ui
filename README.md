# dga_ui

A Flutter implementation of the DGA (Saudi Digital Government Authority) **Platforms Code** design system — tokens and components, built to match the Figma source to the pixel and color.

> Not published to pub.dev (`publish_to: none`). Use it as a local/git dependency within your own projects.

#### Images form example

<img width="201" height="437" alt="Button" src="https://github.com/user-attachments/assets/58e41e5b-e2b0-4ce5-b38f-631799e1ee55" />

<img width="201" height="437" alt="TextInputs" src="https://github.com/user-attachments/assets/5e9d0bdb-11d2-4a7c-aac9-1a961a57acfe" />

<img width="201" height="437" alt="Tags" src="https://github.com/user-attachments/assets/87c3cb65-1d6e-4f5a-bd8e-4c055294ee5d" />


## Features

- **Token layer** — primitives, semantic colors (light + dark), spacing, radius, typography, and shadows, all sourced from the design system's token files. `DgaTheme` exposes them to the widget tree; nothing in the component layer hardcodes a color.
- **30+ components** covering actions, forms, data display, navigation, and feedback — see the table below.
- **Light and dark mode**, RTL-aware layouts, and accessible semantics (selection state, labels, roles) throughout.
- **A gallery app** in [`example/`](example) that demos every component live, with light/dark and LTR/RTL toggles.

## Getting started

Add it as a path or git dependency in your app's `pubspec.yaml`:

```yaml
dependencies:
  dga_ui:
    path: ../dga_ui   # or a git: entry pointing at this repo
```

Requires Flutter `>=3.19.0` / Dart `^3.8.0`.

## Usage

Wrap your app in a `DgaTheme` (typically inside `MaterialApp.builder`, so it's available on every route):

```dart
import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => DgaTheme(
        data: const DgaThemeData.light(), // or .dark()
        child: child!,
      ),
      home: const HomePage(),
    );
  }
}
```

Then use components anywhere below it — colors and text styles read from `DgaTheme.of(context)`:

```dart
DgaButton.primary(
  label: 'Continue',
  onPressed: () {},
)

DgaTabBar(
  items: const [
    DgaTabBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
    DgaTabBarItem(
      icon: Icon(Icons.mail_outline),
      label: 'Inbox',
      badge: DgaBadge.count(3),
    ),
  ],
  selectedIndex: selectedIndex,
  onChanged: (i) => setState(() => selectedIndex = i),
)
```

Run the gallery app to see every component, its variants, and states:

```sh
cd example
flutter run
```

## Components

| Category | Components |
|---|---|
| Actions | `DgaButton`, `DgaMenuButton`, `DgaCloseButton`, `DgaFloatingButton`, `DgaLink` |
| Forms & Inputs | `DgaTextInput`, `DgaTextarea`, `DgaDropdownInput`, `DgaSwitch`, `DgaRadio`, `DgaCheckbox`, `DgaRating`, `DgaSlider`, `DgaDatePickerInput`, `DgaCalendar` |
| Data Display | `DgaChip`, `DgaTag`, `DgaStatusTag`, `DgaAvatar`, `DgaCard`, `DgaQuote`, `DgaBadge` |
| Navigation | `DgaTabBar`, `DgaHorizontalTab`, `DgaVerticalTab`, `DgaAccordion`, `DgaContentSwitcher`, `DgaCarousel` |
| Feedback | `DgaTooltip`, `DgaProgressBar`, `DgaCircularProgressBar`, `DgaCircleStepper`, `DgaRadialStepper`, `DgaInlineAlert`, `DgaNotificationToast` |

`DgaNotification` also ships for backward compatibility — new code should use `DgaInlineAlert` / `DgaNotificationToast` instead.

## Conventions

- **`*Button` components** (`DgaButton`, `DgaFloatingButton`, …) expose visual styles as named constructors (`DgaButton.primary(...)`, `.secondaryOutline(...)`) rather than an enum parameter.
- Other components use enums for style/size axes, e.g. `DgaAlertSeverity`, `DgaTextInputSize`.
- `disabled` is always an explicit `bool` parameter — it's never inferred from a null callback.
- Sizing is expressed with `DgaSpacing` / `DgaRadius` tokens wherever the design system defines an equivalent value.

## Testing

```sh
flutter analyze
flutter test
```

Every component ships with widget tests covering its states, both themes, and RTL where relevant.

## Additional information

Component specs are sourced from the DGA Platforms Code Figma files. If a color doesn't exist in the token files, it's called out with a `// new:` comment next to its definition rather than silently introduced.

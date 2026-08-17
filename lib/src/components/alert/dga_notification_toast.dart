import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../_internal/alert_content.dart';
import 'dga_alert_severity.dart';

/// Figma widths: 484 desktop, 343 mobile.
const double _kToastMaxWidth = 484;
const double _kToastMobileWidth = 343;

/// Inset from the viewport edge.
const double _kToastEdgeInset = DgaSpacing.xl;

const Duration _kToastEnter = Duration(milliseconds: 200);
// Exit is shorter than enter so dismissal feels responsive.
const Duration _kToastExit = Duration(milliseconds: 140);

/// An elevated notification card.
///
/// Use the widget directly to place one yourself, or [show] to float one over
/// the app with placement and auto-dismiss handled for you.
class DgaNotificationToast extends StatelessWidget {
  const DgaNotificationToast({
    super.key,
    required this.title,
    this.description,
    this.severity = DgaAlertSeverity.neutral,
    this.actions = const [],
    this.dismissible = true,
    this.onDismiss,
    this.mobile,
    this.icon,
    this.showIcon = true,
  });

  final String title;
  final String? description;
  final DgaAlertSeverity severity;
  final List<Widget> actions;
  final bool dismissible;
  final VoidCallback? onDismiss;

  /// Forces the stacked ("Mobile") layout. Null follows the available width.
  final bool? mobile;
  final Widget? icon;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    // The toast is always the white surface, so its title stays neutral.
    final palette = resolveAlertPalette(severity, c, tinted: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked =
            mobile ??
            (constraints.maxWidth.isFinite &&
                constraints.maxWidth < kAlertStackBreakpoint);

        return Semantics(
          container: true,
          liveRegion: true,
          label: description == null ? title : '$title. $description',
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: stacked ? _kToastMobileWidth : _kToastMaxWidth,
            ),
            child: AlertSurface(
              palette: palette,
              severity: severity,
              title: title,
              description: description,
              actions: actions,
              dismissible: dismissible,
              onDismiss: onDismiss,
              showIcon: showIcon,
              icon: icon,
              stacked: stacked,
              elevated: true,
              // The card reads off the page via its shadow; Figma draws no
              // border on the toast.
              showBorder: false,
            ),
          ),
        );
      },
    );
  }

  /// Floats a toast over the nearest root [Overlay].
  ///
  /// One toast is on screen at a time; calling [show] while another is up
  /// queues this one to play after it. Returns a handle so the caller can
  /// dismiss it early — or drop it from the queue before it ever appears.
  /// Pass `Duration.zero` to disable auto-dismiss.
  ///
  /// Placement, duration and motion aren't specified by the design — these are
  /// sensible defaults and all are overridable.
  static DgaToastHandle show(
    BuildContext context, {
    required String title,
    String? description,
    DgaAlertSeverity severity = DgaAlertSeverity.neutral,
    List<Widget> actions = const [],
    Duration duration = const Duration(seconds: 5),
    DgaToastPlacement placement = DgaToastPlacement.topCenter,
    bool dismissible = true,
    Widget? icon,
    bool showIcon = true,
  }) {
    final request = _QueuedToast(
      overlay: Overlay.of(context, rootOverlay: true),
      placement: placement,
      duration: duration,
      builder: (dismiss) => DgaNotificationToast(
        title: title,
        description: description,
        severity: severity,
        actions: actions,
        dismissible: dismissible,
        icon: icon,
        showIcon: showIcon,
        onDismiss: dismiss,
      ),
    );
    _LiveToast.enqueue(request);
    return DgaToastHandle._(request);
  }
}

/// Lets a caller dismiss a toast early, or cancel it while it's still queued.
class DgaToastHandle {
  DgaToastHandle._(this._request);

  final _QueuedToast _request;

  /// True only while the toast is actually on screen — a queued one waiting
  /// its turn reports false.
  bool get isVisible => _request.isVisible;

  void dismiss() => _request.dismiss();
}

/// A toast that has been requested but may not have been shown yet.
class _QueuedToast {
  _QueuedToast({
    required this.overlay,
    required this.placement,
    required this.duration,
    required this.builder,
  });

  final OverlayState overlay;
  final DgaToastPlacement placement;
  final Duration duration;
  final Widget Function(VoidCallback dismiss) builder;

  /// Set once this request is mounted.
  _LiveToast? live;

  /// Set when dismissed while still waiting, so it's skipped on its turn.
  bool cancelled = false;

  bool get isVisible => live != null && !live!.gone;

  void dismiss() {
    if (live != null) {
      live!.dismiss();
      return;
    }
    cancelled = true;
  }
}

/// The single live toast: owns its overlay entry, timer and visibility flag.
///
/// Visibility is a [ValueNotifier] rather than widget state so the whole
/// presenter stays a plain object — no host StatefulWidget, GlobalKey or
/// registry needed.
class _LiveToast {
  _LiveToast(this._request);

  /// The toast currently on screen, if any.
  static _LiveToast? current;

  /// Requests waiting for the slot, oldest first.
  static final List<_QueuedToast> _pending = [];

  /// The overlay the queue is currently bound to.
  static OverlayState? _attachedOverlay;

  /// Shows [request] now if the slot is free, otherwise queues it.
  static void enqueue(_QueuedToast request) {
    // If the overlay changed, whatever we were tracking belongs to a tree
    // that's gone (new route stack, restart, or a fresh widget test). Without
    // this, a toast torn down with its overlay — never dismissed, so `current`
    // stays set — would leave every future toast queued behind a ghost.
    if (_attachedOverlay != null && _attachedOverlay != request.overlay) {
      current = null;
      _pending.clear();
    }
    _attachedOverlay = request.overlay;

    if (current != null) {
      _pending.add(request);
      return;
    }
    _mount(request);
  }

  static void _mount(_QueuedToast request) {
    final toast = _LiveToast(request);
    request.live = toast;
    current = toast;
    toast._insert();
  }

  /// Hands the slot to the next request that hasn't been cancelled.
  static void _showNext() {
    while (_pending.isNotEmpty) {
      final next = _pending.removeAt(0);
      if (next.cancelled) continue;
      _mount(next);
      return;
    }
  }

  final _QueuedToast _request;
  final ValueNotifier<bool> _visible = ValueNotifier(false);
  OverlayEntry? _entry;
  Timer? _timer;
  bool gone = false;

  void _insert() {
    _entry = OverlayEntry(
      builder: (_) => _ToastSlot(
        placement: _request.placement,
        visible: _visible,
        child: _request.builder(dismiss),
      ),
    );
    _request.overlay.insert(_entry!);

    // Flip to visible on the next frame so the slide/fade actually plays.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!gone) _visible.value = true;
    });

    if (_request.duration > Duration.zero) {
      _timer = Timer(_request.duration, dismiss);
    }
  }

  void dismiss() {
    if (gone) return;
    gone = true;
    _timer?.cancel();
    _visible.value = false;
    if (current == this) current = null;
    // Let the exit transition finish before tearing down and handing the
    // slot to whatever is queued behind this one.
    Timer(_kToastExit, () {
      _teardown();
      _showNext();
    });
  }

  void _teardown() {
    if (_entry?.mounted ?? false) _entry!.remove();
    _entry = null;
    _visible.dispose();
  }
}

/// Positions the toast in the overlay and runs its enter/exit transition.
class _ToastSlot extends StatelessWidget {
  const _ToastSlot({
    required this.placement,
    required this.visible,
    required this.child,
  });

  final DgaToastPlacement placement;
  final ValueListenable<bool> visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final top = placement.isTop;

    // An Overlay has no Material ancestor, and Text without one renders with
    // Flutter's yellow double-underline fallback. The transparency type adds
    // no surface of its own — the toast card draws that itself.
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(_kToastEdgeInset),
          child: Align(
            alignment: placement.alignment,
            child: ValueListenableBuilder<bool>(
              valueListenable: visible,
              builder: (context, isVisible, _) {
                final d = isVisible ? _kToastEnter : _kToastExit;
                return AnimatedSlide(
                  // Fraction of the card's own height, so it scales with it.
                  offset: reduceMotion || isVisible
                      ? Offset.zero
                      : Offset(0, top ? -0.25 : 0.25),
                  duration: d,
                  curve: isVisible ? Curves.easeOut : Curves.easeIn,
                  child: AnimatedOpacity(
                    opacity: isVisible ? 1 : 0,
                    duration: d,
                    child: child,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

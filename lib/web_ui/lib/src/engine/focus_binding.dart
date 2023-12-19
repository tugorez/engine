import 'dom.dart';

class FocusBinding {
  FocusBinding._();
  static final FocusBinding instance = FocusBinding._();

  late final Stream<FocusBindingChange> onFlutterViewFocusChange =
    _flutterViewFocusChangeController.stream;

  final StreamController<FocusBindingChange> _flutterViewFocusChangeController =
    StreamController<FocusBindingChange>();

  late final DomEventListener _focusChangeHandler =
    createDomEventListener((DomEvent event) {
      final target = event.target as DomElement;
      final relatedTarget = event.relatedTarget as DomElement?;
      final int? flutterViewId = target.flutterViewId;
      final FocusDirection focusDirection = target.focusDirectionFrom(relatedTarget);

      _flutterViewFocusChangeController.add(
        FocusBindingChange(
          flutterViewId: flutterViewId,
          focusDirection: focusDirection,
        ),
      );
    });

  void initialize() {
    domWindow.addEventListener(_focusEventName, _focusChangeHandler, true);
  }

  void reset() {
    domWindow.removeEventListener(_focusEventName, _focusChangeHandler, true);
  }
}

class FocusBindingChange {
  final int? flutterViewId;
  final FocusDirection focusDirection;

  FocusBindingChange({
    this.flutterViewId,
    required this.focusDirection,
  });
}

enum FocusDirection {
  forward,
  backwards,
}

const _focusEventName = 'focusin';

extension on DomElement {
  int? get flutterViewId {
    if (tagName == 'FLUTTER-VIEW') {
      return int.parse(getAttribute('flt-view-id') ?? '1');
    }
    return parent?.flutterViewId;
  }

  FocusDirection focusDirectionFrom(DomElement? previouslyFocusedElement) {
    if (previouslyFocusedElement == null) return FocusDirection.forward;
    if (compareDocumentPosition(previouslyFocusedElement) == 4) return FocusDirection.backwards;
    return FocusDirection.forward;
  }
}

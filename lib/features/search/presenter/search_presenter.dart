import 'package:sabbar/sabbar.dart';

final Debouncer debouncer = Debouncer(delay: const Duration(milliseconds: 300));
void searchChangeListener(BuildContext context) {
  debouncer.call(() {});
}

class Debouncer {
  final Duration? delay;
  Timer? _timer;

  Debouncer({this.delay});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay!, action);
  }

  /// Notifies if the delayed call is active.
  bool get isRunning => _timer?.isActive ?? false;

  /// Cancel the current delayed call.
  void cancel() => _timer?.cancel();
}

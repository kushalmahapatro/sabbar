import 'package:sabbar/features/places/places.dart';
import 'package:sabbar/sabbar.dart';
import 'package:uuid/uuid.dart';

class PlacesBloc extends Bloc<LoadAction, FetchLoadPlaceResult?> {
  var session = const Uuid().v4();

  PlacesBloc() : super(null) {
    on<LoadPlaceAction>((event, emit) async {
      if (event.value.isNotEmpty) {
        final result = await fetchSuggestions(event.value, session);
        emit(
          FetchLoadPlaceResult(
            suggestions: result,
            uiType: event.uiType,
          ),
        );
      } else {
        emit(
          FetchLoadPlaceResult(
            suggestions: event.suggestions ?? <Suggestions>[],
            uiType: event.uiType,
          ),
        );
      }
    });
  }
}

enum UiType { collapsed, expanded }

@immutable
class LoadPlaceAction implements LoadAction {
  final String value;
  final UiType uiType;
  final List<Suggestions>? suggestions;
  const LoadPlaceAction(
      {required this.value,
      this.uiType = UiType.collapsed,
      this.suggestions = const <Suggestions>[]})
      : super();
}

@immutable
class FetchLoadPlaceResult implements FetchResult {
  final List<Suggestions> suggestions;
  final UiType uiType;

  const FetchLoadPlaceResult({
    required this.suggestions,
    required this.uiType,
  });
}

@immutable
class LocationResult implements FetchResult {}

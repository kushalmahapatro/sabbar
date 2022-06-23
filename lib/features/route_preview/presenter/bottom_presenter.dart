import 'package:sabbar/sabbar.dart';

enum TripStatus {
  notSarted,
  started,
  reached,
  pickup,
  onway,
  delivered,
  complete
}

class BottomBloc extends Bloc<LoadAction, FetchResult> {
  BottomBloc(BuildContext context)
      : super(const DriverSelectedResult(
            marker: Marker(markerId: MarkerId('')))) {
    on<DriverSelectedAction>((event, emit) async {
      emit(DriverSelectedResult(marker: event.marker));
    });

    on<PlaceSelectedAction>((event, emit) async {
      emit(PlaceSelectedResult(address: event.address));
    });

    on<TripChangeAction>((event, emit) async {
      if (event.status == TripStatus.started) {
        emit(event.oldResult
            .copyWith(status: event.status, startTime: DateTime.now()));
      } else if (event.status == TripStatus.pickup) {
        emit(event.oldResult
            .copyWith(status: event.status, pickTime: DateTime.now()));
      } else if (event.status == TripStatus.delivered) {
        emit(event.oldResult
            .copyWith(status: event.status, dropTime: DateTime.now()));
      } else {
        emit(event.oldResult.copyWith(status: event.status));
      }
    });
  }
}

class TripBloc extends Bloc<LoadAction, FetchResult> {
  TripBloc(BuildContext context)
      : super(const TripChangeResult(status: TripStatus.notSarted)) {
    on<TripChangeAction>((event, emit) async {
      if (event.status == TripStatus.started) {
        emit(event.oldResult
            .copyWith(status: event.status, startTime: DateTime.now()));
      } else if (event.status == TripStatus.pickup) {
        emit(event.oldResult
            .copyWith(status: event.status, pickTime: DateTime.now()));
      } else if (event.status == TripStatus.delivered) {
        emit(event.oldResult
            .copyWith(status: event.status, dropTime: DateTime.now()));
      } else {
        emit(event.oldResult.copyWith(status: event.status));
      }
    });
  }
}

@immutable
class DriverSelectedAction implements LoadAction {
  const DriverSelectedAction({required this.marker}) : super();
  final Marker marker;
}

@immutable
class DriverSelectedResult implements FetchResult {
  const DriverSelectedResult({required this.marker}) : super();
  final Marker marker;
}

@immutable
class PlaceSelectedAction implements LoadAction {
  const PlaceSelectedAction({required this.address}) : super();
  final String address;
}

@immutable
class PlaceSelectedResult implements FetchResult {
  const PlaceSelectedResult({required this.address}) : super();
  final String address;
}

@immutable
class TripChangeAction implements LoadAction {
  const TripChangeAction({required this.status, required this.oldResult})
      : super();
  final TripStatus status;
  final TripChangeResult oldResult;
}

@immutable
class TripChangeResult implements FetchResult {
  const TripChangeResult(
      {required this.status, this.pickTime, this.dropTime, this.startTime})
      : super();
  final TripStatus status;
  final DateTime? startTime;
  final DateTime? pickTime;
  final DateTime? dropTime;

  TripChangeResult copyWith({
    TripStatus? status,
    DateTime? startTime,
    DateTime? pickTime,
    DateTime? dropTime,
  }) {
    return TripChangeResult(
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      pickTime: pickTime ?? this.pickTime,
      dropTime: dropTime ?? this.dropTime,
    );
  }
}

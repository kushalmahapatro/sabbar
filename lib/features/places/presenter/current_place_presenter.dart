import 'package:sabbar/features/map/map.dart';
import 'package:sabbar/features/places/places.dart';
import 'package:sabbar/sabbar.dart';
import 'package:uuid/uuid.dart';

class CurrentPlaceBloc extends Bloc<LoadAction, FetchSelectPlaceResult?> {
  var session = const Uuid().v4();

  CurrentPlaceBloc(BuildContext context) : super(null) {
    on<SelectPlaceAction>((event, emit) async {
      if (event.pickType == PickType.pickup) {
        if (event.lat != '0' && event.lng != '0') {
          final result = await getPlace(event.lat, event.lng, session);

          emit(event.oldData.copyWith(
              pickType: PickType.pickup,
              pickupData: LocationData(
                  loading: false,
                  initial: event.initial,
                  lat: event.lat,
                  lng: event.lng,
                  address: result)));
        } else {
          emit(event.oldData.copyWith(
              pickupData: LocationData(loading: true, initial: event.initial)));
        }
      } else {
        if (event.lat != '0' && event.lng != '0') {
          final result = await getPlace(event.lat, event.lng, session);

          emit(event.oldData.copyWith(
              pickType: PickType.dropoff,
              dropoffData: LocationData(
                  loading: false,
                  initial: event.initial,
                  lat: event.lat,
                  lng: event.lng,
                  address: result)));
        } else {
          emit(event.oldData.copyWith(
              dropoffData:
                  LocationData(loading: true, initial: event.initial)));
        }
      }
    });

    on<LocationAction>((event, emit) async {
      getPlaceDetailFromId(event.placeId).then((result) {
        event.context.read<MapBloc>().add(LoadMapCameraAction(
            oldResult: event.context.read<MapBloc>().state as MapResult,
            lat: result.latitude ?? 0,
            lng: result.longitude ?? 0));
      });
    });
  }
}

@immutable
class LocationAction implements LoadAction {
  final BuildContext context;
  final String placeId;

  const LocationAction({required this.context, required this.placeId});
}

enum PickType { pickup, dropoff }

@immutable
class SelectPlaceAction implements LoadAction {
  final bool initial;
  final String lat;
  final String lng;
  final bool loading;
  final PickType pickType;
  final FetchSelectPlaceResult oldData;

  const SelectPlaceAction({
    required this.initial,
    required this.oldData,
    this.lat = '0',
    this.lng = '0',
    this.loading = true,
    this.pickType = PickType.pickup,
  }) : super();
}

@immutable
class FetchSelectPlaceResult implements FetchResult {
  final LocationData? pickupData;
  final LocationData? dropoffData;
  final PickType pickType;

  const FetchSelectPlaceResult({
    this.pickupData,
    this.dropoffData,
    this.pickType = PickType.pickup,
  });

  FetchSelectPlaceResult copyWith(
      {LocationData? pickupData,
      LocationData? dropoffData,
      PickType? pickType}) {
    return FetchSelectPlaceResult(
        dropoffData: dropoffData ?? this.dropoffData,
        pickupData: pickupData ?? this.pickupData,
        pickType: pickType ?? this.pickType);
  }
}

class LocationData {
  final bool initial;
  final String lat;
  final String lng;
  final List<String> address;
  final bool loading;

  LocationData(
      {this.initial = true,
      this.lat = '0',
      this.lng = '0',
      this.address = const <String>[],
      this.loading = false});
}

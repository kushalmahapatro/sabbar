import 'package:sabbar/features/places/presenter/presenter.dart';
import 'package:sabbar/sabbar.dart';

class MapBloc extends Bloc<LoadAction, FetchResult> {
  MapBloc(BuildContext context, PickType pickType)
      : super(
            (context.read<CurrentPlaceBloc>().state?.pickupData?.lat ?? '0') !=
                        '0' &&
                    pickType == PickType.pickup
                ? MapResult(size: 40, color: context.colors.primary)
                : ((context.read<CurrentPlaceBloc>().state?.dropoffData?.lat ??
                            '0') !=
                        '0')
                    ? MapResult(size: 40, color: context.colors.primary)
                    : MapResult(size: 0, color: context.colors.onSurface)) {
    on<LoadMapAction>((event, emit) async {
      emit(event.oldResult.copyWith(color: event.color, size: event.size));
    });

    on<LoadMapCameraAction>((event, emit) async {
      if (event.lat == 0 && event.lng == 0) {
        event.oldResult.copyWith(latLng: null);
      } else {
        emit(event.oldResult.copyWith(latLng: LatLng(event.lat, event.lng)));
      }
    });
  }
}

@immutable
class LoadMapAction implements LoadAction {
  const LoadMapAction({required this.oldResult, this.size, this.color})
      : super();
  final double? size;
  final Color? color;
  final MapResult oldResult;
}

@immutable
class LoadMapCameraAction implements LoadAction {
  const LoadMapCameraAction(
      {required this.lat, required this.lng, required this.oldResult})
      : super();

  final double lat;
  final double lng;
  final MapResult oldResult;
}

@immutable
class MapResult implements FetchResult {
  const MapResult({this.size, this.color, this.latLng}) : super();

  final double? size;
  final Color? color;
  final LatLng? latLng;

  MapResult copyWith({double? size, Color? color, LatLng? latLng}) {
    return MapResult(
        color: color ?? this.color, size: size ?? this.size, latLng: latLng);
  }
}

@immutable
class MapCameraResult implements FetchResult {
  const MapCameraResult({this.latLng}) : super();

  final LatLng? latLng;
}

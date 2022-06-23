import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:sabbar/features/route_preview/route_preview.dart';
import 'package:sabbar/sabbar.dart';

class PreviewMapBloc extends Bloc<LoadAction, FetchResult> {
  PreviewMapBloc(BuildContext context)
      : super(const TripPolylineResult(polyline: <LatLng>[])) {
    on<TripPolylineAction>((event, emit) async {
      var value = await getPolyPoints(event.pickup, event.dropOff);
      emit(TripPolylineResult(polyline: value));
    });

    on<NearbyDriverAction>(
      (event, emit) async {
        var value = await getNearbyLocation(event.lat, event.lng);
        emit(NearbyDriverResult(drivers: value.toSet()));
      },
    );

    on<PickupPolylineAction>(
      (event, emit) async {
        var value = await getPolyPoints(event.pickup, event.dropOff);
        emit(PickupPolylineResult(
            polyline: value, markerLocation: event.pickup));
      },
    );

    on<InitialMarkerAction>(
      (event, emit) async {
        Set<Marker> markers = {};
        BitmapDescriptor pickup = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/pickup.png");
        BitmapDescriptor dropoff = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/dropoff.png");
        markers.add(RippleMarker(
            markerId: const MarkerId("Pickup"),
            position: event.pick,
            icon: pickup));

        markers.add(
          RippleMarker(
              markerId: const MarkerId("Dropoff"),
              position: event.drop,
              icon: dropoff),
        );

        emit(InitialMarkerResult(markers: markers));
      },
    );

    on<MoveToMarkerAction>((event, emit) {
      emit(MoveToMarkerResult(marker: event.marker));
    });

    on<UpdateMarkerAction>((event, emit) async {
      BitmapDescriptor truck = BitmapDescriptor.fromBytes(
          await getBytesFromAsset('assets/images/truck.png', 85));

      var marker = RippleMarker(
          anchor: const Offset(1.0, 0.5),
          flat: true,
          markerId: event.id,
          position: event.marker,
          ripple: true,
          icon: truck);

      emit(UpdateMarkerResult(marker: marker, id: event.id));
    });
  }
}

@immutable
class TripPolylineAction implements LoadAction {
  const TripPolylineAction({required this.pickup, required this.dropOff})
      : super();
  final LatLng pickup;
  final LatLng dropOff;
}

@immutable
class PickupPolylineAction implements LoadAction {
  const PickupPolylineAction({required this.pickup, required this.dropOff})
      : super();
  final LatLng pickup;
  final LatLng dropOff;
}

@immutable
class MoveToMarkerAction implements LoadAction {
  const MoveToMarkerAction({required this.marker}) : super();
  final LatLng marker;
}

@immutable
class UpdateMarkerAction implements LoadAction {
  const UpdateMarkerAction(this.marker, this.id) : super();
  final LatLng marker;
  final MarkerId id;
}

@immutable
class TripPolylineResult implements FetchResult {
  const TripPolylineResult({required this.polyline}) : super();

  final List<LatLng> polyline;
}

@immutable
class PickupPolylineResult implements FetchResult {
  const PickupPolylineResult(
      {required this.polyline, required this.markerLocation})
      : super();

  final List<LatLng> polyline;
  final LatLng markerLocation;
}

@immutable
class MoveToMarkerResult implements FetchResult {
  const MoveToMarkerResult({required this.marker}) : super();

  final LatLng marker;
}

@immutable
class UpdateMarkerResult implements FetchResult {
  const UpdateMarkerResult({required this.marker, required this.id}) : super();

  final RippleMarker marker;
  final MarkerId id;
}

@immutable
class NearbyDriverAction implements LoadAction {
  const NearbyDriverAction({required this.lat, required this.lng}) : super();
  final double lat;
  final double lng;
}

@immutable
class NearbyDriverResult implements FetchResult {
  final Set<Marker> drivers;

  const NearbyDriverResult({required this.drivers}) : super();
}

@immutable
class InitialMarkerAction implements LoadAction {
  final LatLng pick;
  final LatLng drop;

  const InitialMarkerAction({required this.pick, required this.drop}) : super();
}

@immutable
class InitialMarkerResult implements FetchResult {
  final Set<Marker> markers;

  const InitialMarkerResult({required this.markers}) : super();
}
